# Artisanal CLI

Use `package:artisanal/args.dart` for `CommandRunner`/`Command` and
`package:artisanal/artisanal.dart` for `Console`. Trust real `lib/*.dart`
barrels over stale README entrypoint names.

```dart
final runner = CommandRunner<void>(
  CommandRunner.detectExecutableName(),
  'Application operations',
)..addCommand(ServeCommand());

await runner.run(arguments);
```

Keep commands thin: parse and validate arguments, call an application or
operations service, render the result, and choose an exit status. Inject output
for tests. Useful commands include migration wrappers, outbox repair, task
enqueue/inspection, worker health, and local multi-process development.

Reuse the same use cases as HTTP routes and server actions; do not call those
transports internally. Do not use `print()` inside a full-screen TUI; use
captured output or `Cmd.println`. Tests must not depend on a real TTY.
