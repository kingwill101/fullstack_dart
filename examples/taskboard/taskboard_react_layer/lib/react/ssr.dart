import 'package:react_server/react_server.dart';

import 'package:taskboard_react_layer/.generated/react/app.react.dart';
import 'package:taskboard_react_layer/.generated/react_components.g.dart';
import 'package:taskboard_react_layer/.generated/ssr_registry.g.dart';

void main() {
  registerReactComponents();
  SsrComponentRegistry.register(
    idApp.value,
    (props) => App(title: props['title'] as String? ?? 'Hello from SSR'),
  );
  registerGlobalRenderer((id, props) => SsrComponentRegistry.build(id, props));
}
