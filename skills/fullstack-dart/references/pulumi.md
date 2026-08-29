# Pulumi Dart deployment

Pulumi Dart is community-maintained and requires all three parts:

- Dart SDK `>=3.11.0 <4.0.0`;
- the Pulumi CLI;
- `pulumi-language-dart` on the real process `PATH`.

Install the SDK helper and matching language host:

```console
dart pub global activate pulumi
pulumi-dart install-language-host
pulumi-language-dart -help
```

A minimal program has `Pulumi.yaml`, its own `pubspec.yaml`, and a Dart
entrypoint:

```dart
import 'package:pulumi/pulumi.dart';

class ApplicationStack extends Stack {
  ApplicationStack() {
    // Create provider resources here.
  }
}

Future<void> main() async {
  await Deployment.runOrThrow(() => ApplicationStack());
}
```

Keep infrastructure in a separate `infra/` package. Use provider SDKs such as
AWS, GCP, Azure, Kubernetes, or command packages according to the chosen target.
Keep all provider SDKs and the core runtime on compatible refs/versions.

## Application deployment model

Model the stack's independently scalable workloads:

- Routed HTTP host and built React browser assets;
- React Node SSR worker, or a separately deployed Fetch SSR module;
- Stem worker pools and scheduler;
- Ormed database plus migration job;
- Stem broker/result backend when separate from the database;
- secrets, networking, logs, traces, and health checks.

Build and test application artifacts before `pulumi up`. Pass artifact digests,
image tags, and endpoints into the infrastructure program as configuration.
Avoid shelling out to an unconstrained application build from a resource
constructor.

Use `Input<T>` for resource arguments and compose `Output<T>` with `apply`,
`Output.tuple`, and collection helpers. Never eagerly extract an output. Export
only values consumers need; mark secrets with Pulumi secret configuration and
never expose them as ordinary stack outputs.

## Safe workflow

```console
pulumi stack select dev
pulumi preview
pulumi up
```

- Use distinct stacks and configuration for development, staging, and
  production.
- Review `pulumi preview` before applying. A request to create deployment code
  does not by itself authorize `pulumi up` or destructive changes.
- Run database migrations as an explicit, observable deployment step before
  traffic reaches code requiring the new schema. Prefer backward-compatible
  expand/migrate/contract changes.
- Use health/readiness checks that distinguish Routed, SSR, database, and Stem
  dependencies. A worker usually needs liveness without an HTTP traffic route.
- Protect state backends and secrets providers. Do not commit plaintext stack
  secrets.
- Treat `pulumi destroy`, replacements of stateful resources, and database
  deletion as destructive operations requiring exact target verification and
  explicit authorization.

For local framework development use Git package refs only when needed. Prefer
published packages or immutable refs for deployment projects.
