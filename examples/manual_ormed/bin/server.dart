import 'dart:async';
import 'dart:io';

import 'package:routed/routed.dart';
import 'package:manual_ormed/app.dart' as app;
import 'package:ormed/ormed.dart';

Future<void> main(List<String> args) async {
  // Read configuration from environment variables (Docker-friendly)
  final host = Platform.environment['HOST'] ?? '127.0.0.1';
  final port = int.tryParse(Platform.environment['PORT'] ?? '8080') ?? 8080;

  final Engine engine = await app.createEngine();
  final database = await engine.make<OrmDatabase>();
  await engine.serve(host: host, port: port);
  final shutdown = Completer<void>();
  ProcessSignal.sigint.watch().listen((_) {
    if (!shutdown.isCompleted) shutdown.complete();
  });
  if (!Platform.isWindows) {
    ProcessSignal.sigterm.watch().listen((_) {
      if (!shutdown.isCompleted) shutdown.complete();
    });
  }
  await shutdown.future;
  await engine.close();
  await database.close();
}
