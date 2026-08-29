# Pulumi deployment

Builds local Docker images for Taskboard and Newsletter with Pulumi Dart.

```bash
fvm dart pub get
fvm dart test
fvm dart analyze
fvm exec pulumi stack init dev
fvm exec pulumi config set platform linux/amd64
fvm exec pulumi preview
fvm exec pulumi up
```

Install `pulumi-language-dart` with:

```bash
fvm dart pub global activate pulumi
fvm dart pub global run pulumi:pulumi_dart install-language-host
```

Docker must be running for preview/up because the stack uses the Docker
provider. Use `linux/arm64` for ARM deployments. The unit test uses Pulumi mocks
and does not require Docker.
