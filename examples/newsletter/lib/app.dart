import 'config.dart';

import 'package:routed/routed.dart';
import 'package:newsletter/newsletter_queue.dart';
import 'package:liquify/liquify.dart';

Future<Engine> createEngine({
  NewsletterQueue queue = const SqliteNewsletterQueue(),
  bool initialize = true,
}) async {
  final setup = config();
  final engine = setup.buildEngine();

  if (initialize) {
    await engine.initialize();
  }

  engine.post('/api/subscriptions', (context) async {
    final payload = Map<String, dynamic>.from(
      await context.bindJSON({}) as Map? ?? const {},
    );
    final email = payload['email']?.toString().trim() ?? '';
    if (!_looksLikeEmail(email)) {
      return context.json({
        'error': 'A valid email is required.',
      }, statusCode: 422);
    }
    await queue.enqueueWelcome(email);
    return context.json({'email': email, 'queued': true}, statusCode: 202);
  });

  engine.get('/', (ctx) async {
    final template = Template.fromFile(
      'subscribe.liquid',
      FileSystemRoot('templates'),
      data: {'app_title': 'Dart Dispatch'},
    );
    return ctx.html(template.render());
  });

  return engine;
}

bool _looksLikeEmail(String value) {
  final at = value.indexOf('@');
  return at > 0 && at < value.length - 3 && value.indexOf('.', at) > at + 1;
}
