import 'dart:convert';
import 'package:manual_ormed/app.dart' as app;
import 'package:ormed/ormed.dart';
import 'package:routed/routed.dart';
import 'package:routed_testing/routed_testing.dart';
import 'package:server_testing/server_testing.dart';

void main() {
  group('API', () {
    late TestClient client;
    late Engine engine;
    late OrmDatabase database;

    setUpAll(() async {
      engine = await app.createEngine(databasePath: ':memory:');
      database = await engine.make<OrmDatabase>();
      client = TestClient(RoutedRequestHandler(engine));
    });

    tearDownAll(() async {
      await client.close();
      await engine.close();
      await database.close();
    });

    test(
      'creates, lists, and completes notes without generated models',
      () async {
        final created = await client.post(
          '/api/v1/notes',
          jsonEncode({'title': 'Use the table API'}),
          headers: {
            HttpHeaders.contentTypeHeader: ['application/json'],
          },
        );
        expect(created.statusCode, 201, reason: created.body);
        created.assertJson((json) {
          json
              .where('id', 1)
              .where('title', 'Use the table API')
              .where('completed', false);
        });

        final response = await client.get('/api/v1/notes');
        response.assertStatus(200).assertJson((json) {
          json.has('data', 1).etc();
        });

        final completed = await client.patch('/api/v1/notes/1/complete', '');
        completed.assertStatus(200).assertJson((json) {
          json.where('id', 1).where('completed', true);
        });
      },
    );
  });
}
