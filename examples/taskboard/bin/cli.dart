import 'dart:io';

import 'package:taskboard/cli.dart' as app;

Future<void> main(List<String> args) async {
  exitCode = await app.runCli(args);
}
