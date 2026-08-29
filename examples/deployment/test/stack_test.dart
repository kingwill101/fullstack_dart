import 'package:deployment/stack.dart';
import 'package:pulumi/pulumi.dart' as pulumi;
import 'package:test/test.dart';

void main() {
  tearDown(pulumi.runtime.clearMocks);

  test('registers both application images with the Docker provider', () async {
    final mocks = _RecordingMocks();
    pulumi.runtime.setMocks(
      mocks,
      project: 'fullstack-dart-local',
      stack: 'test',
    );

    final stack = FullstackDartStack();
    for (final output in stack.getOutputProperties()) {
      await output.value.getValue();
    }

    final images = mocks.resources
        .where((resource) => resource.type == 'docker:index/image:Image')
        .toList();
    expect(images.map((image) => image.name), ['taskboard', 'newsletter']);
    expect(images.every((image) => image.inputs['skipPush'] == true), isTrue);
  });
}

class _RecordingMocks implements pulumi.Mocks {
  final resources = <pulumi.MockResourceArgs>[];

  @override
  Future<Map<String, dynamic>> call(pulumi.MockCallArgs args) async => {};

  @override
  Future<(String?, Map<String, dynamic>)> newResource(
    pulumi.MockResourceArgs args,
  ) async {
    resources.add(args);
    return ('${args.name}-id', args.inputs);
  }

  @override
  Future<void> registerResourceOutputs(
    pulumi.MockRegisterResourceOutputsRequest args,
  ) async {}
}
