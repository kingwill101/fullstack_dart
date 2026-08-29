# Full-stack verification

## Harness layers

- `server_testing` owns the framework-neutral `RequestHandler`, `TestClient`,
  transport modes, `TestResponse`, JSON/cookie/header assertions, fixtures, and
  optional browser harness.
- `routed_testing` adapts a real Routed `Engine` through
  `RoutedRequestHandler`. It must use the same provider composition as
  production.
- `property_testing` supplies generators, shrinking, chaos inputs, and stateful
  runners. It is framework-neutral and composes with `TestClient`.

Default to in-memory transport for speed and deterministic handler behavior.
Repeat transport-sensitive contracts with `TransportMode.ephemeralServer` and
a harness-allocated port. Never assume a conventional port belongs to the test.

```dart
final engine = await Engine.create();
engine.get('/ping', (context) => context.text('pong'));
final handler = RoutedRequestHandler(engine);
final client = TestClient.inMemory(handler);

final response = await client.get('/ping');
response.assertStatus(200).assertBodyContains('pong');

await client.close();
await handler.close();
await engine.close();
```

Test in widening rings:

1. Domain/use-case tests with fake ports.
2. Ormed repository and migration tests against the selected database.
3. Stem task tests in memory, then adapter integration tests.
4. Routed handlers with `routed_testing` and real middleware/providers.
5. React component and SSR/action tests with native harnesses.
6. One composed boundary test for every critical business flow.

Use `ReactComponentHarness` for components/hooks/events,
`ServerFunctionHarness` for server-action protocol behavior, and
`SsrTestHarness` or `InMemorySsrHarness` for documents and props. Compose
`ReactTestHarness` with `RoutedRequestHandler` for built assets, SSR, and
actions. Always use harness-allocated ports.

Reserve browser automation for behavior the native harnesses cannot represent.

## Property tests

Use property tests for laws and broad input spaces, not for duplicating a few
examples. Good properties include:

- Ormed generated DTO/codec round trips preserve supported values;
- migration up/down or schema diff operations preserve declared invariants;
- Stem payload codecs round-trip and duplicate task delivery is idempotent;
- Routed path/query/header parsing never produces a 500 for malformed input;
- Liquify layouts render deterministically for generated view DTOs and do not
  expose forbidden values;
- state machines preserve workflow and domain invariants across command
  sequences.

Set or report the random seed, let the runner shrink failures, and retain the
smallest counterexample as an ordinary regression test. Bound generated sizes,
timeouts, and concurrency so failures remain diagnosable.

For an asynchronous write path, test:

- validation/auth failure produces no write or job;
- transaction failure produces no job;
- enqueue/outbox dispatch failure is recoverable;
- duplicate delivery is harmless;
- exhausted retries are visible and reconcilable;
- success updates observable state.

Run `dart analyze`, `dart test`, generators/migration checks, and
`dart run react_tool:react build` for the composed application.

For Pulumi, validate the Dart program and run non-mutating previews in an
isolated test stack. Assert critical stack outputs and policy invariants without
applying to a shared environment.
