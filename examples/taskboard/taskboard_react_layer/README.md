# Taskboard React Layer

This package is the React Dart client and Routed host for the parent Taskboard
application. It demonstrates hydration, generated server functions, SSR test
harnesses, static asset hosting, and composition with the parent's Ormed-backed
`/api/tasks` routes.

## Prerequisites

- Complete the parent package setup first (`cd ..`, then `fvm dart pub get` and
  run its Ormed/build generation).
- Use FVM with Dart 3.12 or newer.
- Install Node.js; `react_tool` uses it to build the browser and SSR artifacts.

## Build and run

From this directory:

```bash
fvm dart pub get
fvm dart run react_tool:react doctor
fvm dart run react_tool:react build
fvm dart run bin/server.dart
```

Open `http://localhost:8080`. The combined entrypoint:

- serves `build/react` (or `web` before a build);
- mounts generated server-action routes;
- mounts the parent package's `/api/tasks` routes;
- creates the default SQLite database under this directory's `database/`.

The page calls the generated client for the server function defined in
`lib/react/greeting.dart`. The authored component is `lib/react/app.dart`.

## SSR modes

The host supports a remote SSR worker when `REACT_SSR_URL` is set. If it is not
set, the same host still serves the React client, server actions, and task API,
but does not delegate the initial document to a remote renderer.

```bash
REACT_SSR_URL=http://127.0.0.1:3001 \
  fvm dart run bin/server.dart
```

Use the React CLI's `serve` workflow when developing the generated client/SSR
pair:

```bash
fvm dart run react_tool:react serve
```

Run `fvm dart run react_tool:react serve --help` for the ports and options
supported by the installed `react_tool` release.

## Test and analyze

Generate contracts before running checks:

```bash
fvm dart run react_tool:react build
fvm dart run react_tool:react analyze
fvm dart test
```

The tests use:

- `ServerFunctionHarness` for generated contract and dispatch behavior;
- `SsrTestHarness` or `InMemorySsrHarness` for rendered document assertions;
- `ReactComponentHarness` for component behavior.

These are fast in-memory tests; they do not boot a Node SSR worker. For an
end-to-end smoke test, run `bin/server.dart` and use a browser to confirm that
the page hydrates, its server function succeeds, and `/api/tasks` is reachable
from the same origin.

## Configuration

| Variable | Default | Description |
| --- | --- | --- |
| `PORT` | `8080` | Combined Routed server port |
| `DB_DEFAULT_PATH` | unset | Preferred parent Taskboard SQLite path when set |
| `DB_PATH` | `database/taskboard.sqlite` | SQLite path when `DB_DEFAULT_PATH` is unset |
| `REACT_SSR_URL` | unset | Remote SSR worker base URL |
| `REACT_ROOT_COMPONENT` | generated app component | Component identifier sent to remote SSR |

## Authored and generated sources

Work primarily in:

- `lib/react/app.dart` for the component tree;
- `lib/react/greeting.dart` for the server function;
- `web/client.dart`, `web/index.html`, and `web/styles.scss` for the browser
  entrypoint and shell;
- `bin/server.dart` for the combined Routed composition root;
- `react.yaml` for React build configuration.

Do not hand-edit `lib/.generated/` or `build/react/`. Regenerate them with
`react_tool` after changing authored components or server functions. VS Code
settings hide these generated directories by default.
