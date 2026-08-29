# Routed integration

For the batteries-included facade:

```dart
import 'package:routed/routed.dart';

registerRoutedProviders();
final engine = await Engine.create();
engine.get('/health', (context) => context.json({'ok': true}));
await engine.serve(port: 8080);
```

Register providers before `Engine.create()`. Configuration belongs in typed
provider constructors; Routed has no global YAML or dotted-key configuration.
Use `routed_core` plus explicit adapters for a slim composition. Host I/O stays
separate: `routed_io` for the VM and `routed_node` for JavaScript hosts.

`react_server_routed` supplies `RoutedReactApplication` for SSR, actions, and a
static fallback. Mount specific API routes first and this fallback last:

```dart
final app = RoutedReactApplication(
  actionRegistry: registry,
  staticHandler: serveStatic,
  indexTemplate: indexTemplate,
  ssr: ReactSsrClient(endpoint: ssrEndpoint),
  rootComponent: 'app.App',
  pageProps: (context) => {'path': context.path},
);
app.mount(engine);
```

Use current signatures from the checked-out refs; do not copy older examples
across versions. Framework adapters depend on `routed_core`, not the full
`routed` facade.
