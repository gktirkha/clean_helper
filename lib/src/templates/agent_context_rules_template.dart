import '../functions/agent_context/agent_context_info.dart';

/// `.agents/rules.md`: hard rules for AI agents in a generated project.
String agentContextRulesTemplate(AgentContextInfo info) {
  final scope = info.apps.isEmpty
      ? ''
      : '''

- **Monorepo:** run clean-helper from the workspace root, with
  `--scope=<app>` before the command (`clean-helper --scope=${info.apps.first.split('/').last} add-feature orders`).
  The root must not have a `lib/` folder.''';
  return '''
# Rules for AI agents

## Scaffold with clean-helper

- Create features, repositories and entities with `clean-helper add-feature`,
  `add-repo` and `add-entity` (see `commands/`). Don't write their files,
  routers or DI wiring by hand.
- Remove features with `clean-helper remove-feature`, never by deleting
  folders.$scope
- Check how config resolves with `clean-helper list-mono-repo-apps` before
  generating code.

## Never edit

- Generated files: `*.g.dart`, `*.freezed.dart`, `*.config.dart`,
  `*.module.dart`, `lib/generated/`. Change the source, then run
  `clean-helper build-runner` (or `bootstrap`).
- `lib/app/router/<app>_router_module.dart` — tool-owned; `add-feature`,
  `remove-feature` and `regenerate-router` rewrite it.
- `analysis_options.yaml` files clean-helper owns; change the shared rules
  in the one with the full rule list.

## Code

- Import `package:material_ui/material_ui.dart`, never
  `package:flutter/material.dart`.
- Keep imports sorted (`directives_ordering`): `dart:`, then `package:`,
  then relative. Use relative imports inside a package or app.
- Data flows as fpdart `TaskEither<Failure, T>` from datasource to use case;
  run it with `.run()` and `fold` the `Either`. Don't throw across layers.
- Retrofit datasources use `@RestApi(callAdapter: ${info.callAdapter})`; API
  errors arrive as `ApiFailure` with the backend's `ErrorModel`.
- DI is get_it + injectable. Blocs are `@injectable`, routers and navigation
  `@lazySingleton`, repositories `@Singleton(as: …)`. Registrations that need
  a device or backend are tagged `@dev` / `@prod` with `@test` stand-ins.
- UI strings come from the localization package (`${info.localization}`), not
  literals; colours and tokens from the theme package (`${info.theme}`).
- Pages are pure UI: they get `<F>Navigation` and read state from the bloc.
  Navigation goes through the navigation interface, not `context.go(...)`
  in widgets.
- Shared code goes in the foundation packages under
  `${info.foundationDir}/`, which must not depend on each other.

## After changing code

- `dart format` must leave nothing to change and `dart analyze` must be
  clean.
''';
}
