import 'dart:io';

import 'package:manual_ormed/cli.dart' as app;

Future<void> main(List<String> args) async {
  exitCode = await app.runCli(args);
}
