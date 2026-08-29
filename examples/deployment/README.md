# Local deployment with Pulumi Dart

This Pulumi Dart project builds the Taskboard and Newsletter Docker images from
their sibling example directories. It demonstrates describing local application
artifacts in Dart and testing the resource graph with Pulumi mocks.

The stack intentionally stops at image creation: it does not push to a registry,
start containers, or provision a cloud runtime. Both Docker image resources use
`skipPush: true` and receive `:local` tags.

## Resources and outputs

| Resource | Build context | Default image |
| --- | --- | --- |
| Taskboard API | `../taskboard` | `fullstack-dart/taskboard:local` |
| Newsletter web | `../newsletter` | `fullstack-dart/newsletter:local` |

The stack exports `platform`, `taskboardImage`, `newsletterImage`, and the
logical process list `taskboard-web`, `newsletter-web`, and
`newsletter-worker`. The process list documents what a complete deployment
needs; this local stack does not create those processes.

## Prerequisites

- FVM and the repository's pinned Dart SDK
- Pulumi CLI
- Docker Engine or Docker Desktop for `preview` and `up`

Install the Dart Pulumi language host once:

```bash
fvm dart pub global activate pulumi
fvm dart pub global run pulumi:pulumi_dart install-language-host
```

## Test the stack

From this directory:

```bash
fvm dart pub get
fvm dart analyze
fvm dart test
```

The test records resources through Pulumi mocks and verifies both image builds
and `skipPush`; it does not require Docker or Pulumi credentials.

## Preview and build images

```bash
fvm exec pulumi stack init dev
fvm exec pulumi config set platform linux/amd64
fvm exec pulumi preview
fvm exec pulumi up
fvm exec pulumi stack output
```

If the `dev` stack already exists, select it instead:

```bash
fvm exec pulumi stack select dev
```

Use `linux/arm64` when the target runtime is ARM:

```bash
fvm exec pulumi config set platform linux/arm64
```

Change the local repository prefix with:

```bash
fvm exec pulumi config set imagePrefix my-org/fullstack-dart
```

Remove Pulumi's recorded resources when finished:

```bash
fvm exec pulumi destroy
fvm exec pulumi stack rm dev
```

Because these are local, unpushed images, removing the Pulumi stack does not
serve as an image-retention policy. Manage the Docker images separately if they
must be deleted.

## Project map

- `Pulumi.yaml` selects the Dart runtime and `bin/deployment.dart` entrypoint.
- `bin/deployment.dart` runs the Pulumi deployment.
- `lib/stack.dart` declares image resources, configuration, and outputs.
- `test/stack_test.dart` validates the resource graph with mocks.

Run Pulumi commands from this directory: the Docker build contexts are relative
to it.
