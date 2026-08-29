import 'package:pulumi/pulumi.dart' as pulumi;
import 'package:pulumi_docker/index.dart' as docker;

class FullstackDartStack extends pulumi.Stack {
  FullstackDartStack() {
    final config = pulumi.Config();
    final platform = config.get('platform') ?? 'linux/amd64';
    final imagePrefix = config.get('imagePrefix') ?? 'fullstack-dart';

    final taskboard = _image(
      name: 'taskboard',
      context: '../taskboard',
      imageName: '$imagePrefix/taskboard:local',
      platform: platform,
    );
    final newsletter = _image(
      name: 'newsletter',
      context: '../newsletter',
      imageName: '$imagePrefix/newsletter:local',
      platform: platform,
    );

    _outputs = [
      pulumi.OutputProperty('platform', pulumi.Output.create(platform)),
      pulumi.OutputProperty('taskboardImage', taskboard.imageName),
      pulumi.OutputProperty('newsletterImage', newsletter.imageName),
      pulumi.OutputProperty(
        'processes',
        pulumi.Output.create([
          'taskboard-web',
          'newsletter-web',
          'newsletter-worker',
        ]),
      ),
    ];
  }

  late final List<pulumi.OutputProperty> _outputs;

  docker.Image _image({
    required String name,
    required String context,
    required String imageName,
    required String platform,
  }) {
    return docker.Image(
      name,
      args: docker.ImageArgs(
        imageName: imageName.input(),
        skipPush: true.input(),
        build: docker.DockerBuild(
          context: context.input(),
          dockerfile: '$context/Dockerfile'.input(),
          platform: platform.input(),
        ).input(),
      ),
      // Dart publication revisions use +1; provider plugins do not.
      options: pulumi.CustomResourceOptions(version: '5.1.0'),
    );
  }

  @override
  List<pulumi.OutputProperty> getOutputProperties() => _outputs;
}
