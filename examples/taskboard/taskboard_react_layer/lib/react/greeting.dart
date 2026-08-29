import 'package:react_actions/react_actions.dart';
import 'package:react_server/react_server.dart';

/// A server function: the implementation runs only on the server, invoked
/// from the browser through the generated client in
/// `.generated/greeting.client.g.dart`.
///
/// Code generation creates the typed ref and browser client in
/// `lib/.generated/`; tests import that canonical contract.
@serverFunction
Future<String> greet(
  ServerFunctionContext context, {
  required String name,
}) async {
  // Simulate async I/O.
  await Future.delayed(const Duration(milliseconds: 5));
  return 'Hello, $name! The server answered at '
      '${DateTime.now().toIso8601String()}.';
}
