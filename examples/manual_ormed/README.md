# Manual Ormed

This project exposes a JSON API using [Routed](https://kingwill101.github.io/routed/)
and Ormed's codegen-optional database API.

It deliberately has no annotated models, `build_runner`, generated registry,
or `*.orm.dart` files. `SqliteDatabase.connect()` returns an `OrmDatabase`, the
schema is created with `executeSchema()`, and CRUD operations use
`database.table('notes')` with ordinary maps.

No `AdHocColumn` declarations are needed. Insert keys define only the mutation
shape, while created and subsequently queried rows still include generated
fields such as the note ID.

## Useful scripts

```bash
fvm dart pub get
```

```
# Run the API locally on port 8080
fvm dart run routed_cli:routed dev
```

### Example requests

```
curl http://localhost:8080/api/v1/health
curl http://localhost:8080/api/v1/notes
curl -X POST http://localhost:8080/api/v1/notes \
  -H 'content-type: application/json' \
  -d '{"title":"Use Ormed without generated models"}'
curl -X PATCH http://localhost:8080/api/v1/notes/1/complete
```

See `lib/app.dart` for the complete route definitions. `test/api_test.dart`
shows how to exercise the engine with `routed_testing`.
