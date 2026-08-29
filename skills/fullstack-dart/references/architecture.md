# Architecture and request flows

## Responsibilities

| Layer | Owns | Must not own |
|---|---|---|
| React Dart | Components, hooks, browser mounting, SSR descriptions, server-function contracts | Database sessions, queue drivers, host internals |
| Liquify | Server-owned textual templates, layouts, blocks, partial resolution | Hydrated UI state, HTTP transport, untrusted global extensions |
| Routed | HTTP routing, middleware, request context, providers, host adapters | Domain rules, React's portable kernel, job execution |
| Ormed | Models, queries, transactions, migrations, database drivers | HTTP responses, UI state, worker lifecycle |
| Stem | Durable jobs, retries, schedules, workflows, result backends | Request context, interactive UI, database rules |
| Artisanal | CLI parsing, console I/O, prompts, terminal UX | Web routing, queue semantics, persistence mapping |
| Pulumi Dart | Cloud resources, environment config, secrets, dependencies, stack outputs | Application use cases, request handling, runtime queries |

Put business rules in an application/domain package imported by all adapters.
Define small ports there when a use case needs persistence, jobs, clocks, or an
external service; implement those ports in infrastructure packages.

## Flows

Synchronous:

`browser -> Routed -> validation/auth -> use case -> Ormed transaction -> response`

Asynchronous:

`request/action -> use case -> transaction(state + outbox) -> response`

`dispatcher -> Stem enqueue -> worker -> use case -> Ormed transaction`

Mount specific Routed API routes before the React application fallback. For
direct enqueue after commit, document how missed enqueues are detected and
repaired. Give tasks idempotency keys and make retries safe.

## Processes

- HTTP host: Ormed resources, Stem producer, Routed engine, React adapter.
- React SSR: generated Node worker or separately deployed Fetch target.
- Stem worker: typed task registry and queue consumer.
- Stem scheduler: scheduled-task producer, when needed.
- CLI: only resources needed by the selected Artisanal command.
- Infrastructure: Pulumi program that provisions the hosts, database, queue,
  secrets, networking, and artifact configuration for the other processes.

Use distinct entrypoints even when local development launches them together.
