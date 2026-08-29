# Taskboard React Layer

A React Dart application hosted by Routed. It includes server-side rendering and
server functions.

## Setup

```sh
fvm dart pub get
```

## Build

```sh
fvm dart run react_tool:react build
```

## Run

```sh
fvm dart run react_tool:react serve
```

The server runs on `http://localhost:8080` and the SSR worker on port
`3001`. Server functions live in `lib/react/greeting.dart` and are called from
`lib/react/app.dart` through the generated client
(`lib/.generated/react/greeting.client.g.dart`).

For day-to-day iteration, the scaffold focuses on:

- `lib/react/app.dart`
- `lib/react/greeting.dart`

Generated output is in `lib/.generated/` and `build/react`.

VS Code users get `.vscode/settings.json` preconfigured to hide generated and
build artifacts (`.generated`, `build`, `.dart_tool`) from the Explorer by
default.

## Test

```sh
# Generate contracts, then run fast harness tests.
fvm dart run react_tool:react build
fvm dart test
```

Tests use `react_testing`:

- `ServerFunctionHarness` for server-function contract and dispatch checks.
- `SsrTestHarness`/`InMemorySsrHarness` for SSR document assertions.
- `ReactComponentHarness` for component behavior.
- Transported full-stack checks can use `RoutedRequestHandler` from
  `routed_testing`.

The generated tests are fast harness tests. They do not build or boot the Node
SSR worker; add a separate integration test when validating the deployed
application stack.

## Analyze

```sh
fvm dart run react_tool:react analyze
# verbose
fvm dart run react_tool:react analyze --verbose
```

Uses `react_analysis` for component, hook and SSR diagnostics (same engine as
the IDE plugin). Run `fvm dart run react_tool:react doctor` to check setup.

This layer imports the parent Taskboard composition root, so React SSR, server
actions, and the Ormed-backed `/api/tasks` routes share one HTTP process.
