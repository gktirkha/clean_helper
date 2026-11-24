import '../functions/agent_context/agent_context_info.dart';

/// `.agents/rules.md`: hard rules for AI agents in a generated project.
String agentContextRulesTemplate(AgentContextInfo info) {
  final scope = info.apps.isEmpty
      ? ''
      : '''

- Monorepo: run clean-helper from the workspace root with `--scope=<app>`
  before the command (`clean-helper --scope=${info.apps.first.split('/').last} add-feature orders`).
  The root has no `lib/`.''';
  return '''
# Rules for AI agents

`test/architecture_test.dart` in each app checks most of these. Keep it
passing; change it only when a rule changes.

## Scaffold with clean-helper

- Create features, repositories and entities with `add-feature`, `add-repo`
  and `add-entity`. Never hand-write their files, routers or DI wiring.
- Remove features with `remove-feature`, never by deleting folders.$scope
- `add-feature` makes `router/` and `presentation/` only. `add-repo` adds
  `domain/` and `data/`; use it whenever a feature needs data.

## Features are independent

- A feature never imports another feature: not its routes, navigation,
  bloc, entities, models or use cases.
- To open another feature, add a method to your own `<F>Navigation`
  (`goToCart()`) and implement it in `lib/app/navigation/`.
- Only `lib/app/` knows every feature. Removing a feature changes nothing
  under `lib/features/`.
- A feature's DI module registers only that feature's classes.

## Clean layers

Every feature, shared module and workspace package:
`presentation/ → domain/ ← data/`.

- `presentation/` and `data/` import only `domain/`. `domain/` imports
  neither, and no UI (`material_ui`, `flutter_bloc`, `${info.theme}`, Flutter
  widgets).
- Across modules and packages, import only their `domain/`, never their
  `data/` (presentation may also reuse shared `presentation/` widgets).
- Register implementations against their domain interface
  (`@Singleton(as: FooRepository)`), so only DI and `lib/app/` name `data/`
  classes. Tests may import `data/` for fakes.
- Domain code goes in the lowest module that owns the data: packages hold
  reusable use cases; a feature has `domain/` only for app-specific logic.

## Data layer

- No loose files in `data/`: group them in sub-folders. The usual ones are
  `datasources/`, `repositories/`, `models/` and `constants/`.
- Datasources: `<x>_data_source_base.dart` (interface), `rest_…` (Retrofit),
  `fake_…`, `…_local_data_source.dart` (storage). When a fake exists, tag the
  real one `@prod` and the fake `@dev` / `@test`.
- `<x>_repository_impl.dart` only combines datasources; it never touches
  Dio, storage or fixtures.
- Data flows as fpdart `TaskEither<Failure, T>`; don't throw across layers.

## Shared code

- Business code two or more features use goes in `lib/shared/<module>/`,
  split into `data/`, `domain/`, `presentation/`. `lib/core/` is
  infrastructure only (network, DI, theme): if it knows what an order is,
  it isn't core.
- A module is named after a business area (`cart`, `orders`), never
  `utils`, `common`, `widgets`, `helpers`. Fewer than two features using it
  means it belongs in that feature.
- Shared never imports a feature or `lib/app/`; navigation comes in as
  callbacks. `core` never imports `shared`.
- Declare each module and the modules it may import in `sharedModules` in
  the architecture test. No cycles.

## Packages

- `${info.foundationDir}/` packages depend on no workspace package; `core/`
  packages only on `${info.foundationDir}/`. Modules may depend on each other;
  an app never depends on another app.
- Code more than one app needs goes in a workspace package, not an app.

## Blocs and data classes

- `Bloc`, not `Cubit`.
- One `on<Event>` per bloc, dispatching with the freezed `when` (not
  `maybeWhen`), so a new event fails to compile until handled. Handlers take
  the event's values, not the event.
- Results go back through state (a one-off field, then cleared), not return
  values. Async startup work goes in a `started` event.
- freezed for value types: models, states, view data, config. No
  hand-written `==`, `hashCode` or `copyWith`. State is a freezed class, not
  a record; records are fine for small all-scalar params.

## Never edit

- Generated files (`*.g.dart`, `*.freezed.dart`, `*.config.dart`,
  `*.module.dart`, `lib/generated/`): change the source and run
  `clean-helper build-runner`.
- `lib/app/router/<app>_router_module.dart` (tool-owned) and the
  `analysis_options.yaml` files clean-helper writes.

## Code

- Import `package:material_ui/material_ui.dart`, never
  `package:flutter/material.dart`. Relative imports inside a package or app,
  sorted `dart:`, `package:`, relative.
- UI strings from `${info.localization}`, colours and tokens from
  `${info.theme}`; no literals.
- Pages are pure UI and navigate through `<F>Navigation`, never
  `context.go(...)`.
- After a change, `dart format` leaves nothing to change and
  `dart analyze` is clean.
''';
}
