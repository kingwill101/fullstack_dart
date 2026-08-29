# Taskboard

A Routed + Ormed task API hosted alongside a React Dart client and SSR layer.
The project was initialized by Routed CLI; Ormed and React artifacts were then
created by their respective CLIs.

## Commands

```bash
fvm dart pub get
fvm dart run build_runner build
fvm dart test
```

```
cd taskboard_react_layer
fvm dart pub get
fvm dart run react_tool:react build
fvm dart test
fvm dart run react_tool:react serve
```

- Visit http://localhost:8080 for the React UI.
- Use `GET/POST /api/tasks` and `PATCH /api/tasks/{id}` for the Ormed-backed API.

The React server imports the parent Routed composition root, so SSR, server
actions, and the task API share one HTTP process. The SQLite database is created
under `taskboard_react_layer/database/` when launched from that directory.
