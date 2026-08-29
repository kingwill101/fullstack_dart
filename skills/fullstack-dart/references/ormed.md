# Ormed persistence

Ormed is the `RoutedDart/ormed` workspace. The core package is `ormed`; drivers
include `ormed_sqlite`, `ormed_postgres`, `ormed_mysql`, and `ormed_d1`.

Install aligned package versions and initialize the application:

```console
dart run ormed_cli:ormed init
dart run build_runner build --delete-conflicting-outputs
dart run ormed_cli:ormed makemigrations
dart run ormed_cli:ormed migrate
```

`init` creates the conventional `lib/src/database/datasource.dart`, config,
and migration registry. `ormed.yaml` is optional; without it the CLI defaults
to SQLite at `database/<package>.sqlite` and conventional registry paths.

## Models and lifecycle

Define annotated authored models and generate `*.orm.dart`:

```dart
import 'package:ormed/ormed.dart';

part 'user.orm.dart';

@OrmModel(table: 'users')
class User {
  const User({required this.id, required this.email});

  @OrmField(isPrimaryKey: true, autoIncrement: true)
  final int id;

  @OrmField(isUnique: true)
  final String email;
}
```

Prefer the generated data-source entrypoint:

```dart
final ds = createDataSource();
await ds.init();
try {
  final users = await ds.query<$User>().orderBy('id').limit(100).get();
} finally {
  await ds.dispose();
}
```

Use generated repositories and DTOs for writes:

```dart
await ds.repo<$User>().insert($UserInsertDto(email: email));

await ds.transaction(() async {
  await ds.repo<$User>().insert(user);
  await ds.repo<$OutboxMessage>().insert(message);
});
```

Transactions roll back when the callback throws. Do not leak query/session
objects outside the persistence adapter. Map generated models to domain or
application DTOs at the boundary.

## Migrations and safety

- `make:migration` creates a manual Dart migration; `makemigrations` derives a
  diff from generated model metadata and syncs the registry.
- Use `migrate --pretend` before risky changes. Never run `migrate:fresh`,
  `migrate:reset`, or `db:wipe` against shared/production data without explicit
  authorization and target verification.
- Enable the bundled `ormed` analyzer plugin when useful. Generate models first
  because its index reads `*.orm.dart`.
- Avoid unbounded `get()`/`all()`, update/delete without constraints, offset or
  limit without ordering, and interpolated raw SQL.
- Use `ormedGroup`/`ormedTest` and scaffolded SQLite helpers for isolated tests;
  add driver integration coverage for deployed behavior.

For reliable Ormed-to-Stem handoff, write an outbox row in the same transaction
as domain state, dispatch after commit, and make worker effects idempotent.
