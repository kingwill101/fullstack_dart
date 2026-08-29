import 'dart:convert';
import 'dart:io';

import 'package:newsletter/newsletter_queue.dart';
import 'package:property_testing/property_testing.dart';
import 'package:routed_testing/routed_testing.dart';
import 'package:server_testing/server_testing.dart';
import 'package:newsletter/app.dart' as app;
import 'package:stem/stem.dart';
import 'package:stem_sqlite/stem_sqlite.dart';

void main() {
  test('subscription validates and queues a welcome email', () async {
    final queue = _RecordingQueue();
    final engine = await app.createEngine(queue: queue);
    final client = TestClient(RoutedRequestHandler(engine));

    final response = await client.post(
      '/api/subscriptions',
      jsonEncode({'email': 'reader@example.com'}),
      headers: {
        HttpHeaders.contentTypeHeader: ['application/json'],
      },
    );
    response.assertStatus(HttpStatus.accepted);
    expect(queue.emails, ['reader@example.com']);

    await client.close();
  });

  test('invalid subscriptions do not enqueue work', () async {
    final queue = _RecordingQueue();
    final engine = await app.createEngine(queue: queue);
    final client = TestClient(RoutedRequestHandler(engine));

    final response = await client.post(
      '/api/subscriptions',
      jsonEncode({'email': 'not-an-email'}),
      headers: {
        HttpHeaders.contentTypeHeader: ['application/json'],
      },
    );

    response.assertStatus(HttpStatus.unprocessableEntity);
    expect(queue.emails, isEmpty);
    await client.close();
  });

  test('SQLite queue persists a Stem welcome-email envelope', () async {
    final directory = await Directory.systemTemp.createTemp(
      'fullstack-dart-newsletter-',
    );
    try {
      final queue = SqliteNewsletterQueue(storageDirectory: directory.path);
      await queue.enqueueWelcome('reader@example.com');

      final broker = await SqliteBroker.open(
        File('${directory.path}/stem-broker.sqlite'),
      );
      try {
        final delivery = await broker
            .consume(RoutingSubscription.singleQueue(newsletterQueueName))
            .first
            .timeout(const Duration(seconds: 5));
        expect(delivery.envelope.name, welcomeEmail.name);
        expect(delivery.envelope.args, {'email': 'reader@example.com'});
        await broker.ack(delivery);
      } finally {
        await broker.close();
      }
    } finally {
      await _deleteTemporaryDirectory(directory);
    }
  });

  test('Liquify renders the email layout', () {
    final email = renderWelcomeEmail('reader@example.com');
    expect(email, contains('<!doctype html>'));
    expect(email, contains('reader@example.com'));
    expect(email, contains('Dart Dispatch'));
  });

  test('subscription endpoint survives chaotic email strings', () async {
    final engine = await app.createEngine(queue: _RecordingQueue());
    final client = TestClient(RoutedRequestHandler(engine));
    final runner = PropertyTestRunner<String>(
      Chaos.string(minLength: 0, maxLength: 80),
      (email) async {
        final response = await client.post(
          '/api/subscriptions',
          jsonEncode({'email': email}),
          headers: {
            HttpHeaders.contentTypeHeader: ['application/json'],
          },
        );
        expect(response.statusCode, lessThan(500));
      },
    );
    final result = await runner.run();
    expect(result.success, isTrue, reason: result.report);
    await client.close();
  });
}

class _RecordingQueue implements NewsletterQueue {
  final emails = <String>[];

  @override
  Future<void> enqueueWelcome(String email) async => emails.add(email);
}

Future<void> _deleteTemporaryDirectory(Directory directory) async {
  for (var attempt = 0; attempt < 10; attempt++) {
    try {
      await directory.delete(recursive: true);
      return;
    } on FileSystemException {
      if (attempt == 9) rethrow;
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
  }
}
