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

## Install

Ask Codex to install the tagged skill from GitHub:

```text
Install the fullstack-dart skill from
https://github.com/kingwill101/fullstack_dart/tree/v0.1.0/skills/fullstack-dart
```

For a manual checkout, clone the repository and link the skill into the Codex
skills directory:

```sh
git clone --branch v0.1.0 https://github.com/kingwill101/fullstack_dart.git
mkdir -p ~/.codex/skills
ln -s "$PWD/fullstack_dart/skills/fullstack-dart" ~/.codex/skills/fullstack-dart
```

Start a new Codex turn after installation. Invoke the skill explicitly as
`$fullstack-dart`, or let Codex select it automatically for matching work.

## Runnable examples

- `examples/taskboard`: Routed + Ormed API with a React Dart SSR layer.
- `examples/newsletter`: Routed + Liquify subscription UI and a separate Stem
  worker backed by SQLite.
- `examples/manual_ormed`: Routed + Ormed SQLite using `OrmDatabase` and manual
  table queries without models or code generation.
- `examples/deployment`: Pulumi Dart Docker image stack for both applications.

Every example uses FVM and hosted framework packages. See each example's
README for its exact build, test, and run commands.
