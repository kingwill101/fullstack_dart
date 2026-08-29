import 'package:react_actions/react_actions.dart';
import 'package:react_dom/react_dom.dart';
import 'package:taskboard_react_layer/.generated/react/app.react.dart';
import 'package:taskboard_react_layer/.generated/react_components.g.dart';

void main() {
  initReact();
  registerReactComponents();

  // Server-function calls run through this client.
  runWithServerFunctionClient(
    HttpServerFunctionClient(endpoint: Uri.parse('/__react/actions')),
    () {
      final root = getRoot('app');
      final props = getInitialProps();
      final app = App(title: props['title'] as String? ?? 'Hello from React');
      if (props.isNotEmpty) {
        // The server rendered the same props — hydrate the existing markup.
        hydrate(root, app);
      } else {
        mount(root, app);
      }
    },
  );
}
