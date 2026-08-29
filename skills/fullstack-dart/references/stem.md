# Stem jobs and workflows

Prefer generated typed definitions from `stem_builder`:

```dart
part 'tasks.stem.g.dart';

@TaskDefn(name: 'email.send')
Future<EmailResult> sendEmail(
  EmailArgs args, {
  TaskExecutionContext? context,
}) async => EmailResult(await deliver(args));
```

Run `dart run build_runner build` and enqueue through generated call objects.
`TaskDefinition<TArgs, TResult>` is the typed manual fallback. Raw string/map
handlers under `package:stem/advanced.dart` are for interoperability.

Use `package:stem/stable.dart` in application code and
`package:stem/memory.dart` for local tests. Choose SQLite for local/single-node
work, Redis Streams for queue infrastructure, or Postgres for a durable
database-backed stack.

`StemApp` and `StemWorkflowApp` never start a worker implicitly. Start and stop
worker/runtime lifecycles in their process entrypoints.

Task rules:

- Use stable names, versioned serializable DTOs, and small payloads.
- Pass identifiers, not Ormed models or request contexts.
- Make handlers idempotent before enabling retries.
- Classify retryable and terminal failures.
- Set queue, priority, retry, visibility, and time limits deliberately.
- Use workflows only for multi-step operations that must survive restarts.

Define completion, failure, timeout, and reconciliation behavior; successful
enqueue does not guarantee successful execution.
