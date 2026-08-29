# Liquify templates and layouts

Use Liquify for server-owned textual rendering: HTML pages that do not need
React hydration, email bodies, printable documents, notifications, and reusable
layout/partial systems. Keep React Dart responsible for interactive component
trees and React SSR.

Basic rendering:

```dart
import 'package:liquify/liquify.dart';

final template = Template.parse(
  'Hello, {{ name | escape }}!',
  data: {'name': displayName},
);
final body = template.render();
```

Use async rendering when filters, tags, or template resolution are async:

```dart
final body = await template.renderAsync();
```

## Layouts and roots

```liquid
<!-- templates/layouts/base.liquid -->
<!doctype html>
<html>
<head><title>{% block title %}Application{% endblock %}</title></head>
<body>{% block content %}{% endblock %}</body>
</html>
```

```liquid
{% layout "layouts/base.liquid", title: page_title %}
{% block title %}{{ page_title }}{% endblock %}
{% block content %}{% render "partials/account.liquid" %}{% endblock %}
```

Use `FileSystemRoot` for application templates, `MapRoot` for tests/embedded
templates, and a custom `Root` only when templates genuinely live elsewhere.
Normalize names at the adapter boundary and do not allow user input to select
arbitrary filesystem paths.

## Security and ownership

- Escape values for the output context; a generic tag-stripping filter is not
  an HTML sanitizer.
- For untrusted templates, use `Environment.withStrictMode()` and register only
  approved environment-local filters/tags.
- Prefer environment-scoped registration over global registries in server apps,
  so tests and tenants cannot leak extensions into each other.
- Pass view DTOs/maps, not Ormed models, request contexts, or secrets.
- Cache parsed trusted templates where lifecycle and invalidation are explicit.
- Treat template names and variable keys as contracts and cover them with
  render tests.

Return rendered output through Routed with the correct content type. Do not
embed React hydration markers or browser bundle assumptions in shared Liquify
layouts unless a deliberately hybrid page contract requires them.
