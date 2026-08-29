import 'package:deployment/stack.dart';
import 'package:pulumi/pulumi.dart' as pulumi;

Future<void> main() async {
  await pulumi.Deployment.runOrThrow(() => FullstackDartStack());
}
