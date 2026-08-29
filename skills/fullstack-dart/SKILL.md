---
name: fullstack-dart
description: Build and maintain full-stack Dart applications composed from Routed HTTP, React Dart client/SSR, Liquify templates, Stem jobs, Ormed persistence, Artisanal CLI tooling, Pulumi Dart infrastructure, and the server/property testing stack. Use when designing, scaffolding, integrating, deploying, testing, or troubleshooting an application spanning two or more of these layers.
---

# Full-stack Dart

Treat the application as one Dart domain with several runtime boundaries. Keep
domain types and use cases independent of HTTP, React, queue, database, and CLI
adapters. Prefer explicit composition roots over global service lookup.

## Start with the repository

Before changing an application:

1. Read its `AGENTS.md`, `pubspec.yaml`, existing entrypoints, and tests.
2. Determine which package versions it actually uses. Prefer compatible
   pub.dev releases; reserve path dependencies for local package development
   and Git dependencies for an explicitly requested unreleased fix.
3. Identify its processes: web host, SSR worker, Stem worker/scheduler, and CLI.
4. Identify its deployment stacks and rendered-template roots when present.
5. Preserve generated-file rules from each source repository.
6. When `.fvmrc` exists, run Dart and package CLIs through `fvm dart`; use
   `fvm exec` for tools such as Pulumi that must discover `dart` on `PATH`.

For a new application, read [architecture.md](references/architecture.md) and
[project-layout.md](references/project-layout.md).

## Route by layer

- For Routed APIs, middleware, providers, host choice, or HTTP tests, read
  [routed.md](references/routed.md).
- For React components, browser builds, SSR, server actions, or generated
  sources, read [react.md](references/react.md).
- For queued tasks, workers, retries, scheduling, or workflows, read
  [stem.md](references/stem.md).
- For models, queries, transactions, repositories, migrations, or database
  tests, read [ormed.md](references/ormed.md).
- For commands, terminal output, prompts, and operational tooling, read
  [artisanal.md](references/artisanal.md).
- For Liquid layouts, partials, includes, HTML, or email rendering, read
  [liquify.md](references/liquify.md).
- For infrastructure, environments, secrets, previews, or deployment, read
  [pulumi.md](references/pulumi.md).
- For cross-layer verification, read [testing.md](references/testing.md).

When a package repository provides a more focused skill, read it and let its
current package-specific facts override this umbrella guidance.

## Integration invariants

- HTTP handlers validate/translate transport data and call application use
  cases. Do not place persistence or long-running work directly in route code.
- React server actions use the same application use cases as Routed API routes;
  do not fork business logic between browser and API entrypoints.
- Use React for interactive component trees and hydration. Use Liquify for
  server-owned textual templates and layouts; do not make one impersonate the
  other's rendering model.
- Commit database state before publishing a Stem task that depends on it. For
  reliable atomic handoff, use an outbox persisted in the same transaction and
  dispatched asynchronously.
- Stem task payloads carry stable identifiers and versioned DTOs, not Ormed
  models, database sessions, request contexts, or large mutable aggregates.
- Workers are separate process entrypoints in production. Starting an HTTP
  server must not silently start a worker or scheduler.
- Artisanal commands call application services or administrative adapters. They
  do not duplicate route handlers or reach into framework internals.
- Configuration and secrets enter at composition roots and are passed through
  typed constructors. Keep browser-safe configuration separate from secrets.
- Pulumi owns infrastructure resources and stack outputs, not application
  business logic or runtime service discovery. Deploy built artifacts rather
  than rebuilding unpredictably inside resource constructors.
- Make shutdown explicit: stop accepting requests, stop/await workers, dispose
  Ormed data sources, close queue resources, and terminate SSR resources.

## Generated and unpublished code

Do not hand-edit `*.orm.dart`, `lib/.generated/`, `build/react/`, Stem builder
output, or other generated artifacts. Change authored inputs or generators,
regenerate, then analyze and test.

The React Dart and Routed packages used by this skill are published. Use their
compatible pub.dev releases in applications and examples. `react_tool 0.2.2`
still emits development path/Git references in its `routed` templates, so
normalize the generated `pubspec.yaml` to hosted releases before `pub get`.
Do not replace CLI-generated source structure while correcting dependencies.

## Finish

Run narrow checks for the changed package first, then full application analysis
and tests. Exercise at least one real boundary path for an integration change
(for example request -> use case -> Ormed transaction -> Stem enqueue),
including failure behavior.
