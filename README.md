# Full-stack Dart skill

A reusable agent skill and architecture guide for building applications across
the Routed Dart ecosystem:

- Artisanal for CLI and terminal UX
- Routed for HTTP applications
- React Dart for browser clients, server actions, and SSR
- Liquify for server-rendered templates and layouts
- Ormed for persistence and migrations
- Stem for queues, workers, schedules, and workflows
- Pulumi Dart for infrastructure and deployment
- `server_testing`, `routed_testing`, and `property_testing` for verification

Start with [GUIDE.md](GUIDE.md). The installable skill entrypoint is
[skills/fullstack-dart/SKILL.md](skills/fullstack-dart/SKILL.md).

## Install locally

Copy or symlink `skills/fullstack-dart` into your Codex skills directory, then
invoke it as `$fullstack-dart` or let Codex select it for matching work.

## Runnable examples

- `examples/taskboard`: Routed + Ormed API with a React Dart SSR layer.
- `examples/newsletter`: Routed + Liquify subscription UI and a separate Stem
  worker backed by SQLite.
- `examples/deployment`: Pulumi Dart Docker image stack for both applications.

Every example uses FVM and hosted framework packages. See each example's
README for its exact build, test, and run commands.
