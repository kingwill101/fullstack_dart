# Taskboard React Layer

A React Dart application hosted by Routed. It includes server-side rendering and
server functions.

## Setup

```sh
dart pub get
```

## Build

```sh
dart run react_tool:react build
```

## Run

```sh
dart run react_tool:react serve
```

The server runs on `http://localhost:8080` and the SSR worker on port
`3001`. Server functions live in `lib/greeting.dart` and are called from
`lib/app.dart` through the generated client
(`lib/.generated/greeting.client.g.dart`).

For day-to-day iteration, the scaffold focuses on:

- `lib/app.dart`
- `lib/greeting.dart`

Generated output is in `lib/.generated/` and `build/react`.

VS Code users get `.vscode/settings.json` preconfigured to hide generated and
build artifacts (`.generated`, `build`, `.dart_tool`) from the Explorer by
default.

## Test

```sh
# Fast unit tests (no build)
dart test

# Full-stack SSR + server-function integration (builds + boots Node worker)
dart test -t integration
```

Tests use `react_testing`:

- `ServerFunctionHarness` for server-function contract and dispatch checks.
- `SsrTestHarness`/`InMemorySsrHarness` for SSR document assertions.
- `ReactComponentHarness` for component behavior.
- Transported full-stack checks can use `RoutedRequestHandler` from
  `routed_testing`.

## Analyze

```sh
dart run react_tool:react analyze
# verbose
dart run react_tool:react analyze --verbose
```

Uses `react_analysis` for component, hook and SSR diagnostics (same engine as the IDE plugin). Run `dart run react_tool:react doctor` to check setup.
