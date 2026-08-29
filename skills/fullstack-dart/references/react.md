# React Dart client and SSR

Start supported project shapes with `react_tool`:

```console
dart run react_tool:react init my_app --template client
dart run react_tool:react init my_app --template ssr
dart run react_tool:react init my_app --template routed-minimal
```

Use `client` for browser-only, `ssr` for Shelf-backed full stack, and
`routed`/`routed-minimal` for Shelf-free Routed hosts.

Package boundaries:

- `react_core`: portable components, nodes, hooks, refs, contexts.
- `react_dom`: host factories and mounting.
- `react_js` and `react_web`: browser bindings.
- `react_server`: transport-neutral SSR and server functions.
- `react_server_routed`: Routed transport integration.
- `react_testing`: native harnesses, composed with `routed_testing`.

Consume all React packages from
`https://github.com/kingwill101/react_workspace.git` at one explicit ref. Use
one matching Routed ref for Routed dependencies. Prefer commit SHAs outside
workspace-edge development.

Never hand-edit `lib/.generated/` or `build/react/`. Change authored inputs or
generators, then run:

```console
dart run react_tool:react generate
dart analyze
dart test
dart run react_tool:react build
```

The browser artifact is `build/react/browser.js`. Node and Fetch SSR are
different targets; Fetch output uses `renderToReadableStream` and has no
`node:http` listener.
