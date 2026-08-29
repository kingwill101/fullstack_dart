# Manual Ormed

This example is a Routed JSON API backed by SQLite and Ormed's codegen-free
database API. It shows how to define a schema, inspect migrations, and perform
CRUD operations without annotated models, `build_runner`, a generated registry,
or `*.orm.dart` files.

`SqliteDatabase.connect()` returns an `OrmDatabase`. Startup checks
`SchemaInspector.hasTable('notes')`, applies the schema when needed, and then
uses `database.table('notes')` with ordinary maps. Insert keys describe only the
mutation; returned and subsequently queried rows still include generated
columns such as `id`.

## Prerequisites

- FVM
- Dart 3.12 or newer (the pinned FVM SDK is recommended)

## Run locally

From this directory:

```bash
fvm dart pub get
fvm dart run bin/server.dart
```

The API listens on `http://127.0.0.1:8080` by default. Its SQLite database is
created at `storage/app/manual_ormed.sqlite`.

## API

| Method | Path | Purpose |
| --- | --- | --- |
| `GET` | `/api/v1/health` | Check application and database availability |
| `GET` | `/api/v1/notes` | List notes |
| `GET` | `/api/v1/notes/{id}` | Fetch one note |
| `POST` | `/api/v1/notes` | Create a note from a JSON `title` |
| `PATCH` | `/api/v1/notes/{id}/complete` | Mark a note complete |

Try the complete flow:

```bash
curl http://localhost:8080/api/v1/health
curl -X POST http://localhost:8080/api/v1/notes \
  -H 'content-type: application/json' \
  -d '{"title":"Use Ormed without generated models"}'
curl http://localhost:8080/api/v1/notes
curl -X PATCH http://localhost:8080/api/v1/notes/1/complete
```

## Test and analyze

```bash
fvm dart analyze
fvm dart test
```

The API tests use `routed_testing` and `server_testing` against a temporary
SQLite database.

## Configuration

| Variable | Default | Description |
| --- | --- | --- |
| `HOST` | `127.0.0.1` | HTTP bind address |
| `PORT` | `8080` | HTTP port |
| `DB_PATH` | `storage/app/manual_ormed.sqlite` | SQLite database file |

## Docker

The image uses Dart 3.13 by default and persists `/app/storage` when run through
the included Compose file:

```bash
docker compose up --build
```

## Project map

- `lib/app.dart` defines the schema, migration check, database lifecycle, and
  Routed handlers.
- `bin/server.dart` is the direct HTTP entrypoint.
- `bin/cli.dart` and `lib/{cli,commands,config}.dart` preserve the Routed CLI
  application convention for adding operational commands.
- `test/api_test.dart` exercises the API without starting an external server.
