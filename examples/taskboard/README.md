# Taskboard

Taskboard combines a Routed API, generated Ormed models and migrations, a
SQLite database, and a React Dart client hosted by Routed. It was initialized
with the Routed CLI; Ormed and React sources retain the layouts produced by
their own CLIs.

The repository contains two Dart packages:

- this parent package owns the task domain, Ormed persistence, and `/api/tasks`;
- `taskboard_react_layer/` owns the browser bundle, server functions, optional
  remote SSR integration, and the combined HTTP host.

## Prerequisites

- FVM
- Dart 3.12 or newer (the pinned FVM SDK is recommended)
- Node.js for React Dart builds

## Run the API only

From this directory:

```bash
fvm dart pub get
fvm dart run build_runner build --delete-conflicting-outputs
fvm dart run bin/server.dart
```

The API listens on `http://127.0.0.1:8080` and stores data in
`database/taskboard.sqlite` by default.

## Run the combined React host

Build the parent first, then run the nested package:

```bash
fvm dart pub get
fvm dart run build_runner build --delete-conflicting-outputs
cd taskboard_react_layer
fvm dart pub get
fvm dart run react_tool:react build
fvm dart run bin/server.dart
```

Open `http://localhost:8080`. The nested server serves the React assets,
registers generated server-action routes, and mounts the parent's task API in
one Routed process. Because its working directory is the React package, the
default database is `taskboard_react_layer/database/taskboard.sqlite`.

The current React page is intentionally a small generated server-function
example. Use the JSON API below to exercise task CRUD.

## Task API

| Method | Path | Purpose |
| --- | --- | --- |
| `GET` | `/api/tasks` | List tasks |
| `POST` | `/api/tasks` | Create a task from a JSON `title` |
| `PATCH` | `/api/tasks/{id}` | Set the JSON boolean `completed` state |

```bash
curl -X POST http://localhost:8080/api/tasks \
  -H 'content-type: application/json' \
  -d '{"title":"Ship the Dart stack"}'
curl http://localhost:8080/api/tasks
curl -X PATCH http://localhost:8080/api/tasks/1 \
  -H 'content-type: application/json' \
  -d '{"completed":true}'
```

## Test and analyze

Run checks in both packages:

```bash
fvm dart analyze
fvm dart test
cd taskboard_react_layer
fvm dart run react_tool:react build
fvm dart run react_tool:react analyze
fvm dart test
```

The parent tests cover the Routed/Ormed API. The React tests cover server
function dispatch, SSR documents, and component behavior using in-memory
harnesses. For a browser-level smoke test, start the combined host and verify
that `/`, its generated assets, and `/api/tasks` load from the same origin.

## Configuration

| Variable | Scope | Default | Description |
| --- | --- | --- | --- |
| `HOST` | API-only server | `127.0.0.1` | HTTP bind address |
| `PORT` | both servers | `8080` | HTTP port |
| `DB_DEFAULT_PATH` | database configuration | unset | Preferred SQLite path when set |
| `DB_PATH` | both servers | `database/taskboard.sqlite` | SQLite path when `DB_DEFAULT_PATH` is unset |
| `REACT_SSR_URL` | combined server | unset | Optional remote SSR worker URL |
| `REACT_ROOT_COMPONENT` | combined server | generated app component | SSR root component identifier |

Without `REACT_SSR_URL`, the combined host serves the built client and API
without delegating rendering to a remote SSR worker.

## Generated files

Do not hand-edit Ormed `*.orm.dart` files, `lib/.generated/`, or
`taskboard_react_layer/build/react/`. Change the authored model, component, or
server-function source and rerun the corresponding CLI/build command.

## Docker

The parent Dockerfile builds the API-only `bin/server.dart` entrypoint with
Dart 3.13:

```bash
docker compose up --build
```

Building and packaging the combined React host requires the nested React build
in addition to the parent API build.

## Project map

- `lib/app.dart` creates the Routed engine and Ormed data source.
- `lib/src/tasks/` contains the task model and API routes.
- `bin/server.dart` runs the API-only host.
- `ormed.yaml` configures Ormed generation.
- `taskboard_react_layer/` contains the React Dart application and combined
  server; see its README for layer-specific commands.
