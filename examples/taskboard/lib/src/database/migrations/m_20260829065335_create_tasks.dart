import 'package:ormed/migrations.dart';

class CreateTasks extends Migration {
  const CreateTasks();

  @override
  void up(SchemaBuilder schema) {
    schema.create('tasks', (table) {
      table.column('id', const ColumnType.integer()).nullable().primaryKey().autoIncrement();
      table.column('title', const ColumnType.string());
      table.column('completed', const ColumnType.boolean());
    });
  }

  @override
  void down(SchemaBuilder schema) {
    schema.drop('tasks', ifExists: true);
  }
}
