# Newsletter

Newsletter demonstrates a small multi-process Dart application: Routed accepts
a subscription, Liquify renders the browser page and email layout, and Stem
delivers a typed welcome-email task through a SQLite-backed queue. The HTTP
server and worker remain separate production processes.

## Architecture

```text
browser / HTTP client -> Routed server -> Stem SQLite broker -> Stem worker
                              |                                |
                       Liquify web page                 Liquify email
```

The worker prints the rendered welcome email to standard output; it does not
connect to a real email provider.

## Prerequisites

- FVM
- Dart 3.12 or newer (the pinned FVM SDK is recommended)

## Run locally

Install dependencies and start the web process from this directory:

```bash
fvm dart pub get
fvm dart run bin/server.dart
```

Start the worker in a second terminal:

```bash
fvm dart run bin/worker.dart
```

Open `http://localhost:8080`, enter an email address, and watch the worker
terminal for the rendered message. Both processes must use this directory as
their working directory so they share `storage/app` and can resolve the
`templates` directory.

You can also enqueue directly over HTTP:

```bash
curl -i -X POST http://localhost:8080/api/subscriptions \
  -H 'content-type: application/json' \
  -d '{"email":"reader@example.com"}'
```

A valid request returns `202 Accepted`; an invalid email returns `422`.

## Test and analyze

```bash
fvm dart analyze
fvm dart test
```

The tests cover HTTP validation, the accepted subscription response, and the
typed task envelope written to the SQLite broker. They do not send email.

Stem operational commands are available through the installed development
dependency, for example:

```bash
fvm dart run stem_cli:stem tasks ls
fvm dart run stem_cli:stem worker status
```

## Configuration and data

| Variable | Default | Description |
| --- | --- | --- |
| `HOST` | `127.0.0.1` | HTTP bind address |
| `PORT` | `8080` | HTTP port |
| `WORKER_NAME` | `newsletter-worker` | Stem consumer identity |

The broker and result database are stored as
`storage/app/stem-broker.sqlite` and `storage/app/stem-results.sqlite`.

## Docker

The included image builds the web entrypoint with Dart 3.13. Start it with:

```bash
docker compose up --build
```

For a complete deployment, run `bin/worker.dart` as a second process with the
same persistent `storage/app` volume. The Compose example currently defines
only the web process.

## Project map

- `lib/app.dart` contains the page and subscription route.
- `lib/newsletter_queue.dart` defines the typed task, queue adapter, handler,
  and Liquify email rendering.
- `bin/server.dart` and `bin/worker.dart` are independent composition roots.
- `templates/subscribe.liquid` renders the subscription page.
- `templates/emails/` contains the email template and layout.
- `test/api_test.dart` covers the HTTP-to-queue boundary.
