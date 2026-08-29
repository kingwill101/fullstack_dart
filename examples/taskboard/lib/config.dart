import 'package:routed_core/routed_core.dart';
import 'package:routed_views/routed_views.dart';

/// Typed application wiring shared by the runtime and Routed CLI flows.
///
/// Keep provider-owned configuration beside its provider constructor. Return
/// fresh instances because CLI inspection and deployment may build an engine
/// separately from the running server.
final class AppConfig {
  AppConfig({
    required Iterable<ServiceProvider> providers,
    this.engineConfig,
    RuntimeContext? runtime,
    Iterable<EngineOpt> options = const [],
  }) : providers = List<ServiceProvider>.unmodifiable(providers),
       runtime = runtime ?? RuntimeContext(),
       options = List<EngineOpt>.unmodifiable(options);

  final List<ServiceProvider> providers;
  final RuntimeContext runtime;
  final EngineConfig? engineConfig;
  final List<EngineOpt> options;

  Engine buildEngine() => Engine(
    config: engineConfig,
    runtime: runtime,
    providers: providers,
    options: options,
  );
}

AppConfig config() {
  return AppConfig(
    providers: [
      CoreServiceProvider(),
      RoutingServiceProvider(),
      ViewServiceProvider(
        RoutedViewConfig(directory: 'templates'),
      ),
    ],
  );
}
