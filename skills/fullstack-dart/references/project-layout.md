# Suggested project layout

Adapt this to an existing repository; do not reorganize a working app solely to
match it.

```text
bin/
  server.dart
  worker.dart
  scheduler.dart
  app.dart                 # Artisanal CLI
lib/
  app.dart                 # React root
  ssr.dart                 # React SSR entrypoint
  src/
    domain/
    application/
    infrastructure/
      database/            # Ormed models, datasource, migrations
      jobs/                # Stem definitions and handlers
    presentation/
      http/
      react/
      cli/
  .generated/              # generated; never hand-edit
web/
  client.dart
  styles.scss
templates/
  layouts/
  partials/
  emails/
react.yaml
database/
test/
infra/
  Pulumi.yaml
  pubspec.yaml
  bin/main.dart
```

Typical `react.yaml`:

```yaml
client:
  entrypoint: web/client.dart
ssr:
  entrypoint: lib/ssr.dart
  runtime: node
server:
  entrypoint: bin/server.dart
styles:
  entrypoints: [web/styles.scss]
  output: styles.css
static: web
output: build/react
```

Use `runtime: fetch` only for a Fetch-compatible SSR deployment; `react serve`
starts the Node SSR worker, not the Fetch target.

Database models are not automatically public DTOs or queue payloads. Map at
boundaries so schema, transport, and job contracts can evolve independently.
