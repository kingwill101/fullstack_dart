import 'config.dart';

import 'package:routed/routed.dart';
import 'package:ormed/ormed.dart';
import 'package:taskboard/src/database/datasource.dart';
import 'package:taskboard/src/database/migrations.dart';
import 'package:taskboard/src/tasks/task_routes.dart';

Future<Engine> createEngine({
  DataSource? dataSource,
  bool initialize = true,
}) async {
  final resolvedDataSource = dataSource ?? createDefaultDataSource();
  if (!resolvedDataSource.isInitialized) {
    await resolvedDataSource.init();
    await OrmDatabase(resolvedDataSource).migrateDescriptors(buildMigrations());
  }
  final setup = config();
  final engine = setup.buildEngine();

  if (initialize) {
    await engine.initialize();
  }

  registerTaskRoutes(engine, resolvedDataSource);

  return engine;
}
