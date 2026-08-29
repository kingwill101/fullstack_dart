import 'dart:convert';
import 'dart:io';

import 'package:newsletter/newsletter_queue.dart';
import 'package:property_testing/property_testing.dart';
import 'package:routed_testing/routed_testing.dart';
import 'package:server_testing/server_testing.dart';
import 'package:newsletter/app.dart' as app;

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
