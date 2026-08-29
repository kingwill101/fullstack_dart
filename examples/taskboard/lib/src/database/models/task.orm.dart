// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'task.dart';

// **************************************************************************
// OrmModelGenerator
// **************************************************************************

const FieldDefinition _$TaskIdField = FieldDefinition(
  name: 'id',
  columnName: 'id',
  dartType: 'int',
  resolvedType: 'int?',
  isPrimaryKey: true,
  isNullable: true,
  isUnique: false,
  isIndexed: false,
  autoIncrement: true,
);

const FieldDefinition _$TaskTitleField = FieldDefinition(
  name: 'title',
  columnName: 'title',
  dartType: 'String',
  resolvedType: 'String',
  isPrimaryKey: false,
  isNullable: false,
  isUnique: false,
  isIndexed: false,
  autoIncrement: false,
);

const FieldDefinition _$TaskCompletedField = FieldDefinition(
  name: 'completed',
  columnName: 'completed',
  dartType: 'bool',
  resolvedType: 'bool',
  isPrimaryKey: false,
  isNullable: false,
  isUnique: false,
  isIndexed: false,
  autoIncrement: false,
);

Map<String, Object?> _encodeTaskUntracked(
  Object model,
  ValueCodecRegistry registry,
) {
  final m = model as Task;
  return <String, Object?>{
    'id': registry.encodeField(_$TaskIdField, m.id),
    'title': registry.encodeField(_$TaskTitleField, m.title),
    'completed': registry.encodeField(_$TaskCompletedField, m.completed),
  };
}

final ModelDefinition<$Task> _$TaskDefinition = ModelDefinition(
  modelName: 'Task',
  tableName: 'tasks',
  fields: const [_$TaskIdField, _$TaskTitleField, _$TaskCompletedField],
  relations: const [],
  softDeleteColumn: 'deleted_at',
  metadata: ModelAttributesMetadata(
    hidden: const <String>[],
    visible: const <String>[],
    fillable: const <String>[],
    guarded: const <String>[],
    casts: const <String, String>{},
    appends: const <String>[],
    touches: const <String>[],
    timestamps: true,
    softDeletes: false,
    softDeleteColumn: 'deleted_at',
  ),
  untrackedToMap: _encodeTaskUntracked,
  codec: _$TaskCodec(),
);

extension TaskOrmDefinition on Task {
  static ModelDefinition<$Task> get definition => _$TaskDefinition;
}

class Tasks {
  const Tasks._();

  /// Starts building a query for [$Task].
  ///
  /// {@macro ormed.query}
  static Query<$Task> query([String? connection]) =>
      Model.query<$Task>(connection: connection);

  static Future<$Task?> find(Object id, {String? connection}) =>
      Model.find<$Task>(id, connection: connection);

  static Future<$Task> findOrFail(Object id, {String? connection}) =>
      Model.findOrFail<$Task>(id, connection: connection);

  static Future<List<$Task>> all({String? connection}) =>
      Model.all<$Task>(connection: connection);

  static Future<int> count({String? connection}) =>
      Model.count<$Task>(connection: connection);

  static Future<bool> anyExist({String? connection}) =>
      Model.anyExist<$Task>(connection: connection);

  static Query<$Task> where(
    String column,
    String operator,
    dynamic value, {
    String? connection,
  }) => Model.where<$Task>(column, operator, value, connection: connection);

  static Query<$Task> whereIn(
    String column,
    List<dynamic> values, {
    String? connection,
  }) => Model.whereIn<$Task>(column, values, connection: connection);

  static Query<$Task> orderBy(
    String column, {
    String direction = "asc",
    String? connection,
  }) => Model.orderBy<$Task>(
    column,
    direction: direction,
    connection: connection,
  );

  static Query<$Task> limit(int count, {String? connection}) =>
      Model.limit<$Task>(count, connection: connection);

  /// Creates a [Repository] for [$Task].
  ///
  /// {@macro ormed.repository}
  static Repository<$Task> repo([String? connection]) =>
      Model.repository<$Task>(connection: connection);

  /// Builds a tracked model from a column/value map.
  static $Task fromMap(
    Map<String, Object?> data, {
    ValueCodecRegistry? registry,
  }) => _$TaskDefinition.fromMap(data, registry: registry);

  /// Converts a tracked model to a column/value map.
  static Map<String, Object?> toMap(
    $Task model, {
    ValueCodecRegistry? registry,
  }) => _$TaskDefinition.toMap(model, registry: registry);
}

class TaskModelFactory {
  const TaskModelFactory._();

  static ModelDefinition<$Task> get definition => _$TaskDefinition;

  static ModelCodec<$Task> get codec => definition.codec;

  static Task fromMap(
    Map<String, Object?> data, {
    ValueCodecRegistry? registry,
  }) => definition.fromMap(data, registry: registry);

  static Map<String, Object?> toMap(
    Task model, {
    ValueCodecRegistry? registry,
  }) => definition.toMap(model.toTracked(), registry: registry);

  static void registerWith(ModelRegistry registry) =>
      registry.register(definition);

  static ModelFactoryConnection<Task> withConnection(QueryContext context) =>
      ModelFactoryConnection<Task>(definition: definition, context: context);

  static ModelFactoryBuilder<Task> factory({
    GeneratorProvider? generatorProvider,
  }) => ModelFactoryRegistry.factoryFor<Task>(
    generatorProvider: generatorProvider,
  );
}

class _$TaskCodec extends ModelCodec<$Task> {
  const _$TaskCodec();
  @override
  Map<String, Object?> encode($Task model, ValueCodecRegistry registry) {
    return <String, Object?>{
      'id': registry.encodeField(_$TaskIdField, model.id),
      'title': registry.encodeField(_$TaskTitleField, model.title),
      'completed': registry.encodeField(_$TaskCompletedField, model.completed),
    };
  }

  @override
  $Task decode(Map<String, Object?> data, ValueCodecRegistry registry) {
    final int? taskIdValue = registry.decodeField<int?>(
      _$TaskIdField,
      data['id'],
    );
    final String taskTitleValue =
        registry.decodeField<String>(_$TaskTitleField, data['title']) ??
        (throw StateError('Field title on Task cannot be null.'));
    final bool taskCompletedValue =
        registry.decodeField<bool>(_$TaskCompletedField, data['completed']) ??
        (throw StateError('Field completed on Task cannot be null.'));
    final model = $Task(
      id: taskIdValue,
      title: taskTitleValue,
      completed: taskCompletedValue,
    );
    model._attachOrmRuntimeMetadata({
      'id': taskIdValue,
      'title': taskTitleValue,
      'completed': taskCompletedValue,
    });
    return model;
  }
}

/// Insert DTO for [Task].
///
/// Auto-increment/DB-generated fields are omitted by default.
class TaskInsertDto implements InsertDto<$Task> {
  const TaskInsertDto({this.title, this.completed});
  final String? title;
  final bool? completed;

  @override
  Map<String, Object?> toMap() {
    return <String, Object?>{
      if (title != null) 'title': title,
      if (completed != null) 'completed': completed,
    };
  }

  static const _TaskInsertDtoCopyWithSentinel _copyWithSentinel =
      _TaskInsertDtoCopyWithSentinel();
  TaskInsertDto copyWith({
    Object? title = _copyWithSentinel,
    Object? completed = _copyWithSentinel,
  }) {
    return TaskInsertDto(
      title: identical(title, _copyWithSentinel)
          ? this.title
          : title as String?,
      completed: identical(completed, _copyWithSentinel)
          ? this.completed
          : completed as bool?,
    );
  }
}

class _TaskInsertDtoCopyWithSentinel {
  const _TaskInsertDtoCopyWithSentinel();
}

/// Update DTO for [Task].
///
/// All fields are optional; only provided entries are used in SET clauses.
class TaskUpdateDto implements UpdateDto<$Task> {
  const TaskUpdateDto({this.id, this.title, this.completed});
  final int? id;
  final String? title;
  final bool? completed;

  @override
  Map<String, Object?> toMap() {
    return <String, Object?>{
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (completed != null) 'completed': completed,
    };
  }

  static const _TaskUpdateDtoCopyWithSentinel _copyWithSentinel =
      _TaskUpdateDtoCopyWithSentinel();
  TaskUpdateDto copyWith({
    Object? id = _copyWithSentinel,
    Object? title = _copyWithSentinel,
    Object? completed = _copyWithSentinel,
  }) {
    return TaskUpdateDto(
      id: identical(id, _copyWithSentinel) ? this.id : id as int?,
      title: identical(title, _copyWithSentinel)
          ? this.title
          : title as String?,
      completed: identical(completed, _copyWithSentinel)
          ? this.completed
          : completed as bool?,
    );
  }
}

class _TaskUpdateDtoCopyWithSentinel {
  const _TaskUpdateDtoCopyWithSentinel();
}

/// Partial projection for [Task].
///
/// All fields are nullable; intended for subset SELECTs.
class TaskPartial implements PartialEntity<$Task> {
  const TaskPartial({this.id, this.title, this.completed});

  /// Creates a partial from a database row map.
  ///
  /// The [row] keys should be column names (snake_case).
  /// Missing columns will result in null field values.
  factory TaskPartial.fromRow(Map<String, Object?> row) {
    return TaskPartial(
      id: row['id'] as int?,
      title: row['title'] as String?,
      completed: row['completed'] as bool?,
    );
  }

  final int? id;
  final String? title;
  final bool? completed;

  @override
  $Task toEntity() {
    // Basic required-field check: non-nullable fields must be present.
    final String? titleValue = title;
    if (titleValue == null) {
      throw StateError('Missing required field: title');
    }
    final bool? completedValue = completed;
    if (completedValue == null) {
      throw StateError('Missing required field: completed');
    }
    return $Task(id: id, title: titleValue, completed: completedValue);
  }

  @override
  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (completed != null) 'completed': completed,
    };
  }

  static const _TaskPartialCopyWithSentinel _copyWithSentinel =
      _TaskPartialCopyWithSentinel();
  TaskPartial copyWith({
    Object? id = _copyWithSentinel,
    Object? title = _copyWithSentinel,
    Object? completed = _copyWithSentinel,
  }) {
    return TaskPartial(
      id: identical(id, _copyWithSentinel) ? this.id : id as int?,
      title: identical(title, _copyWithSentinel)
          ? this.title
          : title as String?,
      completed: identical(completed, _copyWithSentinel)
          ? this.completed
          : completed as bool?,
    );
  }
}

class _TaskPartialCopyWithSentinel {
  const _TaskPartialCopyWithSentinel();
}

/// Generated tracked model class for [Task].
///
/// This class extends the user-defined [Task] model and adds
/// attribute tracking, change detection, and relationship management.
/// Instances of this class are returned by queries and repositories.
///
/// **Do not instantiate this class directly.** Use queries, repositories,
/// or model factories to create tracked model instances.
class $Task extends Task with ModelAttributes implements OrmEntity {
  /// Internal constructor for [$Task].
  $Task({int? id, required String title, bool completed = false})
    : super(id: id, title: title, completed: completed) {
    _attachOrmRuntimeMetadata({
      'id': id,
      'title': title,
      'completed': completed,
    });
  }

  /// Creates a tracked model instance from a user-defined model instance.
  factory $Task.fromModel(Task model) {
    return $Task(id: model.id, title: model.title, completed: model.completed);
  }

  $Task copyWith({int? id, String? title, bool? completed}) {
    return $Task(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }

  /// Builds a tracked model from a column/value map.
  static $Task fromMap(
    Map<String, Object?> data, {
    ValueCodecRegistry? registry,
  }) => _$TaskDefinition.fromMap(data, registry: registry);

  /// Converts this tracked model to a column/value map.
  Map<String, Object?> toMap({ValueCodecRegistry? registry}) =>
      _$TaskDefinition.toMap(this, registry: registry);

  /// Tracked getter for [id].
  @override
  int? get id => getAttribute<int?>('id') ?? super.id;

  /// Tracked setter for [id].
  set id(int? value) => setAttribute('id', value);

  /// Tracked getter for [title].
  @override
  String get title => getAttribute<String>('title') ?? super.title;

  /// Tracked setter for [title].
  set title(String value) => setAttribute('title', value);

  /// Tracked getter for [completed].
  @override
  bool get completed => getAttribute<bool>('completed') ?? super.completed;

  /// Tracked setter for [completed].
  set completed(bool value) => setAttribute('completed', value);

  void _attachOrmRuntimeMetadata(Map<String, Object?> values) {
    replaceAttributes(values);
    attachModelDefinition(_$TaskDefinition);
  }
}

class _TaskCopyWithSentinel {
  const _TaskCopyWithSentinel();
}

extension TaskOrmExtension on Task {
  static const _TaskCopyWithSentinel _copyWithSentinel =
      _TaskCopyWithSentinel();
  Task copyWith({
    Object? id = _copyWithSentinel,
    Object? title = _copyWithSentinel,
    Object? completed = _copyWithSentinel,
  }) {
    return Task(
      id: identical(id, _copyWithSentinel) ? this.id : id as int?,
      title: identical(title, _copyWithSentinel) ? this.title : title as String,
      completed: identical(completed, _copyWithSentinel)
          ? this.completed
          : completed as bool,
    );
  }

  /// Converts this model to a column/value map.
  Map<String, Object?> toMap({ValueCodecRegistry? registry}) =>
      _$TaskDefinition.toMap(this, registry: registry);

  /// Builds a model from a column/value map.
  static Task fromMap(
    Map<String, Object?> data, {
    ValueCodecRegistry? registry,
  }) => _$TaskDefinition.fromMap(data, registry: registry);

  /// The Type of the generated ORM-managed model class.
  /// Use this when you need to specify the tracked model type explicitly,
  /// for example in generic type parameters.
  static Type get trackedType => $Task;

  /// Converts this immutable model to a tracked ORM-managed model.
  /// The tracked model supports attribute tracking, change detection,
  /// and persistence operations like save() and touch().
  $Task toTracked() {
    return $Task.fromModel(this);
  }
}

extension TaskPredicateFields on PredicateBuilder<Task> {
  PredicateField<Task, int?> get id => PredicateField<Task, int?>(this, 'id');
  PredicateField<Task, String> get title =>
      PredicateField<Task, String>(this, 'title');
  PredicateField<Task, bool> get completed =>
      PredicateField<Task, bool>(this, 'completed');
}

void registerTaskEventHandlers(EventBus bus) {
  // No event handlers registered for Task.
}
