import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:react_server/react_server.dart';
import 'package:routed_core/routed_core.dart';
import 'package:routed_io/routed_io.dart';
import 'package:react_server_routed/react_server_routed.dart';
import 'package:taskboard_react_layer/.generated/server_actions.g.dart';
import 'package:taskboard/app.dart' as taskboard_app;
import 'package:taskboard/src/database/datasource.dart';

const _defaultRootComponent =
    'package:taskboard_react_layer/lib/react/app.dart#App';

Future<void> main() async {
  await Directory('database').create(recursive: true);
  final dataSource = createDefaultDataSource();
  final port = int.tryParse(Platform.environment['PORT'] ?? '') ?? 8080;
  final webDir = Directory('build/react').existsSync()
      ? Directory('build/react')
      : Directory('web');
  final indexTemplate = File(
    p.join(webDir.path, 'index.html'),
  ).readAsStringSync();

  final actionRegistry = ServerFunctionRegistry();
  registerServerActions(registry: actionRegistry);

  final ssrUrl = Platform.environment['REACT_SSR_URL'];
  final ssr = ssrUrl == null
      ? null
      : ReactSsrClient(endpoint: Uri.parse(ssrUrl));
  final reactApp = RoutedReactApplication(
    actionRegistry: actionRegistry,
    staticHandler: (context) => _serveStatic(context, webDir),
    indexTemplate: indexTemplate,
    ssr: ssr,
    rootComponent:
        Platform.environment['REACT_ROOT_COMPONENT'] ?? _defaultRootComponent,
    pageProps: (request) => {'title': 'Hello from SSR'},
  );

  final engine = await taskboard_app.createEngine(
    dataSource: dataSource,
    initialize: false,
  );
  engine.get('/', reactApp.handler);
  reactApp.mount(engine);
  await engine.initialize();
  await serveIo(engine, host: InternetAddress.anyIPv4.address, port: port);
  final shutdown = Completer<void>();
  ProcessSignal.sigint.watch().listen((_) {
    if (!shutdown.isCompleted) shutdown.complete();
  });
  if (!Platform.isWindows) {
    ProcessSignal.sigterm.watch().listen((_) {
      if (!shutdown.isCompleted) shutdown.complete();
    });
  }
  await shutdown.future;
  await engine.close();
  await dataSource.dispose();
}

Future<Response> _serveStatic(EngineContext context, Directory webDir) async {
  final requested = context.path == '/'
      ? 'index.html'
      : context.path.substring(1);
  final relative = p.normalize(requested);
  if (relative == '..' ||
      relative.startsWith('../') ||
      p.isAbsolute(relative)) {
    return context.string('Not found', statusCode: HttpStatus.notFound);
  }

  final file = File(p.join(webDir.path, relative));
  if (!file.existsSync()) {
    return context.string('Not found', statusCode: HttpStatus.notFound);
  }

  context.setHeader('content-type', _contentType(file.path));
  context.setHeader('cache-control', 'no-cache');
  context.response.writeBytes(await file.readAsBytes());
  await context.close();
  return context.response;
}

String _contentType(String path) => switch (p.extension(path).toLowerCase()) {
  '.css' => 'text/css; charset=utf-8',
  '.html' => 'text/html; charset=utf-8',
  '.js' => 'text/javascript; charset=utf-8',
  '.mjs' => 'text/javascript; charset=utf-8',
  '.json' => 'application/json',
  '.svg' => 'image/svg+xml',
  '.wasm' => 'application/wasm',
  _ => 'application/octet-stream',
};
