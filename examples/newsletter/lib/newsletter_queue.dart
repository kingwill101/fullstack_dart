import 'dart:io';

import 'package:liquify/liquify.dart';
import 'package:stem/stem.dart';
import 'package:stem_sqlite/stem_sqlite.dart';

const newsletterQueueName = 'newsletter';

class WelcomeEmailArgs {
  const WelcomeEmailArgs({required this.email});

  final String email;
}

final welcomeEmail = TaskDefinition<WelcomeEmailArgs, void>(
  name: 'newsletter.send_welcome',
  encodeArgs: (args) => {'email': args.email},
  metadata: const TaskMetadata(
    description: 'Render and deliver the welcome email.',
    tags: ['newsletter', 'email'],
  ),
  defaultOptions: const TaskOptions(queue: newsletterQueueName),
);

class SendWelcomeEmailTask extends TaskHandler<void> {
  @override
  String get name => welcomeEmail.name;

  @override
  TaskMetadata get metadata => welcomeEmail.metadata;

  @override
  TaskOptions get options => welcomeEmail.defaultOptions;

  @override
  Future<void> call(TaskContext context, Map<String, Object?> args) async {
    final email = args['email'] as String;
    final body = renderWelcomeEmail(email);
    stdout.writeln('Delivered welcome email to $email:\n$body');
  }
}

String renderWelcomeEmail(String email) {
  final root = FileSystemRoot('templates/emails');
  return Template.fromFile(
    'welcome.liquid',
    root,
    data: {'email': email, 'product_name': 'Dart Dispatch'},
  ).render();
}

abstract interface class NewsletterQueue {
  Future<void> enqueueWelcome(String email);
}

class SqliteNewsletterQueue implements NewsletterQueue {
  const SqliteNewsletterQueue({this.storageDirectory = 'storage/app'});

  final String storageDirectory;

  @override
  Future<void> enqueueWelcome(String email) async {
    final directory = Directory(storageDirectory)..createSync(recursive: true);
    final broker = await SqliteBroker.open(
      File('${directory.path}/stem-broker.sqlite'),
    );
    final backend = await SqliteResultBackend.open(
      File('${directory.path}/stem-results.sqlite'),
    );
    final registry = InMemoryTaskRegistry()..register(SendWelcomeEmailTask());
    final stem = Stem(broker: broker, backend: backend, registry: registry);
    try {
      await stem.enqueueCall(
        welcomeEmail.buildCall(WelcomeEmailArgs(email: email)),
      );
    } finally {
      await broker.close();
      await backend.close();
    }
  }
}

List<TaskHandler<Object?>> newsletterTasks() => [SendWelcomeEmailTask()];
