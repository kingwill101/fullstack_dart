import 'package:ormed/ormed.dart';

part 'task.orm.dart';

@OrmModel(table: 'tasks')
class Task extends Model<Task> {
  const Task({this.id, required this.title, this.completed = false});

  @OrmField(isPrimaryKey: true, autoIncrement: true)
  final int? id;

  final String title;

  final bool completed;
}
