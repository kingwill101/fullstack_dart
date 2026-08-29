import 'package:ormed/ormed.dart';
import 'package:taskboard/src/database/config.dart';
import 'package:taskboard/src/database/datasource.dart';

final Map<String, DataSource> _generatedTestDataSources =
    <String, DataSource>{};

final Map<String, OrmedTestConfig> _generatedTestConfigs =
    <String, OrmedTestConfig>{};

DataSource _ensureGeneratedTestDataSource(String connection) {
  final existing = _generatedTestDataSources[connection];
  if (existing != null) {
    return existing;
  }
  final created = createDataSource(connection: connection);
  _generatedTestDataSources[connection] = created;
  return created;
}

OrmedTestConfig _ensureGeneratedTestConfig(String connection) {
  final existing = _generatedTestConfigs[connection];
  if (existing != null) {
    return existing;
  }
  final created = setUpOrmed(
    dataSource: _ensureGeneratedTestDataSource(connection),
    migrations: const [_CreateTestUsersTable()],
  );
  _generatedTestConfigs[connection] = created;
  return created;
}

OrmedTestConfig testConfig({String? connection}) {
  final selectedConnection = (connection ?? defaultDataSourceConnection).trim();
  final selectedConfig = _generatedTestConfigs[selectedConnection];
  if (selectedConfig == null) {
    if (!generatedDataSourceConnections.contains(selectedConnection)) {
      throw ArgumentError.value(
        selectedConnection,
        'connection',
        'Generated test helper has a single datasource connection: default',
      );
    }
    return _ensureGeneratedTestConfig(selectedConnection);
  }
  return selectedConfig;
}

OrmConnection testConnection({String? connection}) {
  final selectedConnection = (connection ?? defaultDataSourceConnection).trim();
  if (!_generatedTestConfigs.containsKey(selectedConnection)) {
    if (!generatedDataSourceConnections.contains(selectedConnection)) {
      throw ArgumentError.value(
        selectedConnection,
        'connection',
        'Generated test helper has a single datasource connection: default',
      );
    }
    _ensureGeneratedTestConfig(selectedConnection);
  }
  return ConnectionManager.instance.connection(selectedConnection);
}

/// Convenience test config for "default" connection.
final OrmedTestConfig defaultTestConfig = testConfig(connection: 'default');

/// Convenience test connection for "default".
OrmConnection defaultTestConnection() {
  return testConnection(connection: 'default');
}

class _CreateTestUsersTable extends Migration {
  const _CreateTestUsersTable();

  @override
  Future<void> up(SchemaBuilder schema) async {
    schema.create('users', (table) {
      table.integer('id').primaryKey().autoIncrement();
      table.string('email').unique();
      table.string('name');
    });
  }

  @override
  Future<void> down(SchemaBuilder schema) async {
    schema.drop('users', ifExists: true);
  }
}
