import 'package:react_dom/react_dom.dart';

/// Root component. `title` is supplied by the server during SSR.
///
/// Uses the typed host elements from `package:react_dom` for browser and SSR.
/// After codegen you can wire the generated `greetAction`:
///
/// ```dart
/// // import '.generated/greeting.client.g.dart' show greetAction;
/// // useEffect(() { greetAction(name: 'world').then(setMessage); }, []);
/// ```
@reactComponent
ReactNode App(({String title}) props) {
  return div(
    className: classNames('app-shell'),
    style: css(
      fontFamily: 'system-ui, sans-serif',
      maxWidth: 640,
      margin: '0 auto',
      padding: '48px 24px',
      textAlign: 'center',
    ),
    additionalProps: dataAttributes({'app': 'react-dart'}),
    children: [
      h1(key: 'title', children: [props.title]),
      div(
        key: 'welcome',
        children: ['Hello! — edit lib/app.dart to get started.'],
      ),
      div(
        key: 'instructions',
        children: ['Edit lib/app.dart and rebuild to see changes.'],
      ),
    ],
  );
}
