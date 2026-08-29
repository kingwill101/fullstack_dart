import 'dart:async';
import 'dart:io';

import 'package:newsletter/newsletter_queue.dart';
import 'package:stem/stem.dart';
import 'package:stem_sqlite/stem_sqlite.dart';

Future<void> main() async {
  final directory = Directory('storage/app')..createSync(recursive: true);
  final broker = await SqliteBroker.open(
    File('${directory.path}/stem-broker.sqlite'),
  );
  final backend = await SqliteResultBackend.open(
    File('${directory.path}/stem-results.sqlite'),
  );
  final worker = Worker(
    broker: broker,
    backend: backend,
    tasks: newsletterTasks(),
    queue: newsletterQueueName,
    consumerName: Platform.environment['WORKER_NAME'] ?? 'newsletter-worker',
  );

  Future<void> shutdown() async {
    await worker.shutdown(mode: WorkerShutdownMode.warm);
    await broker.close();
    await backend.close();
  }

  ProcessSignal.sigint.watch().listen((_) => unawaited(shutdown()));
  if (!Platform.isWindows) {
    ProcessSignal.sigterm.watch().listen((_) => unawaited(shutdown()));
  }
  await worker.start();
}
