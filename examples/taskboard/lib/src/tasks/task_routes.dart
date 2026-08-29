import 'package:ormed/ormed.dart';
import 'package:routed/routed.dart';
import 'package:taskboard/src/database/models/task.dart';

void registerTaskRoutes(Engine engine, DataSource dataSource) {
  engine.group(
    path: '/api',
    builder: (router) {
      router.get('/tasks', (context) async {
        final tasks = await dataSource.query<$Task>().orderBy('id').get();
        return context.json({'data': tasks.map(_toJson).toList()});
      });

      router.post('/tasks', (context) async {
        final payload = Map<String, dynamic>.from(
          await context.bindJSON({}) as Map? ?? const {},
        );
        final title = payload['title']?.toString().trim() ?? '';
        if (title.isEmpty) {
          return context.json({
            'error': 'A non-empty title is required.',
          }, statusCode: 422);
        }
        final task = await dataSource.repo<$Task>().insert(
          TaskInsertDto(title: title, completed: false),
        );
        return context.json(_toJson(task), statusCode: 201);
      });

      router.patch('/tasks/{id}', (context) async {
        final id = int.tryParse(context.mustGetParam<String>('id'));
        if (id == null) {
          return context.json({'error': 'Invalid task id.'}, statusCode: 400);
        }
        final payload = Map<String, dynamic>.from(
          await context.bindJSON({}) as Map? ?? const {},
        );
        final completed = payload['completed'];
        if (completed is! bool) {
          return context.json({
            'error': 'A boolean completed value is required.',
          }, statusCode: 422);
        }
        final existing = await dataSource.repo<$Task>().find(id);
        if (existing == null) {
          return context.json({'error': 'Task not found.'}, statusCode: 404);
        }
        final task = await dataSource.repo<$Task>().update(
          TaskUpdateDto(completed: completed),
          where: {'id': id},
        );
        return context.json(_toJson(task));
      });
    },
  );
}

Map<String, Object?> _toJson($Task task) => {
  'id': task.id,
  'title': task.title,
  'completed': task.completed,
};
