import 'dart:io';

import 'config.dart';

import 'package:ormed/ormed.dart';
import 'package:ormed_sqlite/ormed_sqlite.dart';
import 'package:routed/routed.dart';

Map<String, Object?> _jsonRow(AdHocRow row) => row.map((key, value) {
  if (key == 'completed' && value is int) {
    return MapEntry(key, value != 0);
  }
  return MapEntry(key, value is DateTime ? value.toIso8601String() : value);
});

Query<AdHocRow> _notes(OrmDatabase database) => database.table('notes');

Future<Engine> createEngine({
  bool initialize = true,
  String? databasePath,
}) async {
  final database = await SqliteDatabase.connect(
    path:
        databasePath ??
        Platform.environment['DB_PATH'] ??
        'storage/app/manual_ormed.sqlite',
  );
  final schema = SchemaInspector(database.driver as SchemaDriver);
  if (!await schema.hasTable('notes')) {
    await database.executeSchema((schema) {
      schema.create('notes', (table) {
        table.id();
        table.string('title');
        table.boolean('completed').defaultValue(false);
        table.timestamps();
      });
    }, description: 'Create the codegen-free notes table');
  }

  final setup = config(database);
  final engine = setup.buildEngine();

  if (initialize) {
    await engine.initialize();
  }

  engine.group(
    path: '/api/v1',
    builder: (router) {
      router.get('/health', (ctx) async {
        return ctx.json({'status': 'ok'});
      });

      router.get('/notes', (ctx) async {
        final notes = await _notes(database).orderBy('id').get();
        return ctx.json({'data': notes.map(_jsonRow).toList()});
      });

      router.get('/notes/{id}', (ctx) async {
        final id = int.parse(ctx.mustGetParam<String>('id'));
        final note = await ctx.fetchOr404(
          () => _notes(database).whereEquals('id', id).first(),
          message: 'Note not found',
        );
        return ctx.json(_jsonRow(note));
      });

      router.post('/notes', (ctx) async {
        final payload = Map<String, dynamic>.from(
          await ctx.bindJSON({}) as Map? ?? const {},
        );
        final title = payload['title']?.toString().trim() ?? '';
        if (title.isEmpty) {
          return ctx.json({
            'error': 'title is required',
          }, statusCode: HttpStatus.unprocessableEntity);
        }
        final now = DateTime.now().toUtc();
        final created = await _notes(database).create({
          'title': title,
          'completed': false,
          'created_at': now,
          'updated_at': now,
        });
        return ctx.json(_jsonRow(created), statusCode: HttpStatus.created);
      });

      router.patch('/notes/{id}/complete', (ctx) async {
        final id = int.parse(ctx.mustGetParam<String>('id'));
        final updated = await _notes(database).whereEquals('id', id).update({
          'completed': true,
          'updated_at': DateTime.now().toUtc(),
        });
        if (updated == 0) {
          return ctx.json({
            'error': 'Note not found',
          }, statusCode: HttpStatus.notFound);
        }
        final note = await _notes(
          database,
        ).whereEquals('id', id).firstOrFail(key: id);
        return ctx.json(_jsonRow(note));
      });
    },
  );

  return engine;
}
