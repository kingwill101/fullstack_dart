# Newsletter

A Routed subscription page that queues a typed Stem task. A separate worker
renders the welcome message through a Liquify email layout.

## Commands

```bash
fvm dart pub get
fvm dart test
```

```
fvm dart run bin/server.dart
```

In a second terminal:

```bash
fvm dart run bin/worker.dart
```

Visit http://localhost:8080 and subscribe. The HTTP process enqueues to SQLite;
the worker consumes from the `newsletter` queue and prints the rendered email.
Stem operational commands are available through
`fvm dart run stem_cli:stem`, for example `tasks ls` and `worker status`.
