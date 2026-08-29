# Full-stack Dart guide

This stack uses Dart across terminal tooling, HTTP, browser UI, server-side
rendering, persistence, and background work:

| Concern | Package |
|---|---|
| CLI and terminal UX | Artisanal |
| HTTP application and hosts | Routed |
| React components, browser client, SSR, server actions | React Dart (`react_core` ecosystem) |
| Server-owned layouts, partials, HTML and email templates | Liquify |
| Persistence and migrations | Ormed |
| Queues, workers, schedules, durable workflows | Stem |
| Infrastructure and deployments | Pulumi Dart |
| Server, Routed, and generative verification | `server_testing`, `routed_testing`, `property_testing` |

The central rule is that these are adapters around application use cases, not
five places to implement business logic.

## Recommended shape

Keep domain types and use cases in framework-independent libraries. Routed
routes, React server actions, Stem handlers, and Artisanal commands translate
their inputs and invoke those use cases. Ormed repositories implement the
persistence ports used by those use cases.

A web process composes Routed, an Ormed `DataSource`, a Stem producer, and
`RoutedReactApplication`. A production worker is a separate entrypoint that
composes Stem task definitions and the resources their handlers need. React's
SSR runtime may be a generated Node worker or separately deployed Fetch module.
Artisanal supplies operational commands without becoming a service locator.
Liquify renders server-owned templates such as emails, printable documents, or
non-hydrated HTML. Pulumi Dart provisions and connects the independently
deployable processes and their backing services.

## Reliable write flow

For state changes that trigger background work:

1. Validate and authorize at the Routed/server-action boundary.
2. Run the use case in an Ormed transaction.
3. Persist both domain state and an outbox record.
4. Commit, then have a dispatcher enqueue the outbox event to Stem.
5. Make the Stem handler idempotent and update durable status.
6. Expose status to React through a normal query/action path.

Direct enqueue after commit is simpler when occasional enqueue failure is
acceptable and repairable. It is not atomic with the database write.

## Package choices

- Use the `routed` facade for the official provider catalogue; use
  `routed_core` and explicit adapters for a slim host.
- Use React's Routed-specific template (`routed-minimal` for the smallest
  authored starter) to avoid adding Shelf.
- Prefer typed, generated Stem task definitions over string/map handlers.
- Initialize Ormed through the generated `datasource.dart`, use generated DTOs
  and companions, and dispose the data source at shutdown.
- Use Liquify inheritance for server-owned layouts and strict, environment-local
  tags/filters when templates are not fully trusted.
- Keep Pulumi in a separate infrastructure package with one stack per
  environment; preview changes before applying them.
- Use `server_testing` as the transport-neutral harness, `routed_testing` as the
  Routed adapter, and `property_testing` for generators, shrinking, chaos, and
  stateful invariants.
- Pin all React packages to one Git ref and all Routed packages to one matching
  ref until they are published compatibly; prefer immutable SHAs in deployments.

## Source status

This guide was derived on 2026-08-28 from the local Artisanal and Routed
repositories and the current `master` branches of `kingwill101/stem`,
`kingwill101/react_workspace`, `RoutedDart/ormed`, `kingwill101/liquify`,
`kingwill101/pulumi-dart`, `RoutedDart/server_testing`, and
`kingwill101/property_testing`. The reusable agent
instructions live in [`skills/fullstack-dart/SKILL.md`](skills/fullstack-dart/SKILL.md).
