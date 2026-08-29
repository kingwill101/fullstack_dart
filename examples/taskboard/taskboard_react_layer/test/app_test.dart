import 'package:react_core/react.dart';
import 'package:react_testing/react_testing.dart';
import 'package:test/test.dart';

import 'package:taskboard_react_layer/app.dart';

void main() {
  test('component harness renders the root host node', () {
    final harness = ReactComponentHarness();
    final node = harness.run(() => App((title: 'Taskboard')));
    expect(node, isA<HostNode>());
    harness.assertHostNode(node, namespace: 'html', name: 'div');
  });

  test('in-memory SSR injects markup and serialized props', () {
    final harness = InMemorySsrHarness(
      indexTemplate: '<main>{{SSR}}</main><script>{{PROPS}}</script>',
    );
    final document = harness.render(
      renderedHtml: '<div>Taskboard</div>',
      props: {'title': 'Taskboard'},
    );
    harness.assertDocument(
      document,
      containsHtml: 'Taskboard',
      containsProps: {'title': 'Taskboard'},
    );
  });
}
