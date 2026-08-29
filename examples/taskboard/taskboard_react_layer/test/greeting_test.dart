import 'package:react_testing/react_testing.dart';
import 'package:test/test.dart';

import 'package:taskboard_react_layer/greeting.dart';
import 'package:taskboard_react_layer/.generated/greeting.action.g.dart';

void main() {
  test('server function dispatches through the React harness', () async {
    final harness = ServerFunctionHarness();
    harness.registry.register(
      greetRef,
      (args, context) => greet(context, name: args.name),
    );

    final result = await harness.dispatch(greetRef, (name: 'Dart'));
    expect(result, contains('Hello, Dart!'));
  });
}
