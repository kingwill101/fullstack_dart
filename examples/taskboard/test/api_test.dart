import 'dart:convert';
import 'dart:io';

import 'package:ormed/ormed.dart';
import 'package:ormed_sqlite/ormed_sqlite.dart';
import 'package:routed_testing/routed_testing.dart';
import 'package:server_testing/server_testing.dart';
import 'package:taskboard/app.dart' as app;
import 'package:taskboard/src/database/datasource.dart';
import 'package:taskboard/src/database/migrations.dart';
import 'package:taskboard/src/database/orm_registry.g.dart';

void main() {
  test('task API persists create, list, and completion changes', () async {
    final dataSource = createDataSource(
      options: bootstrapOrm().sqliteInMemoryDataSourceOptions(),
    );
    await dataSource.init();
    await OrmDatabase(dataSource).migrateDescriptors(buildMigrations());
    final engine = await app.createEngine(dataSource: dataSource);
    final client = TestClient(RoutedRequestHandler(engine));

    final created = await client.post(
      '/api/tasks',
      jsonEncode({'title': 'Validate the full stack'}),
      headers: {
        HttpHeaders.contentTypeHeader: ['application/json'],
      },
    );
    created.assertStatus(HttpStatus.created);
    final createdJson = created.json() as Map<String, dynamic>;

    final updated = await client.patch(
      '/api/tasks/${createdJson['id']}',
      jsonEncode({'completed': true}),
      headers: {
        HttpHeaders.contentTypeHeader: ['application/json'],
      },
    );
    updated.assertStatus(HttpStatus.ok);
    expect((updated.json() as Map<String, dynamic>)['completed'], isTrue);

    final listed = await client.get('/api/tasks');
    listed.assertStatus(HttpStatus.ok);
    expect((listed.json() as Map<String, dynamic>)['data'], hasLength(1));

    await client.close();
    await dataSource.dispose();
  });
}
