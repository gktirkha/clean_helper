/// One clean-helper command, described for AI agents working in a generated
/// project. Rendered to `.agents/commands/<name>.md` by
/// `agentContextCommandTemplate`.
typedef AgentCommandDoc = ({
  String name,
  String usage,
  String summary,
  String whenToUse,
  String details,
});

/// The commands an agent may run in a generated project, in the order they
/// are usually needed.
const agentCommandDocs = <AgentCommandDoc>[
  (
    name: 'add-feature',
    usage: 'clean-helper add-feature <feature_name> [--di]',
    summary:
        'Adds a feature: routes, router, navigation, bloc, page provider '
        'and page, and registers its router.',
    whenToUse:
        'Whenever a new screen or flow is needed. Never create a '
        'feature folder or router by hand.',
    details: '''
- The name must be snake_case (`user_profile`). It can't be the app's name.
- Generates `lib/features/<f>/router/` (routes, navigation interface, router),
  `presentation/` (bloc with freezed events/states, page provider, page) and
  `lib/app/navigation/<f>_navigation_impl.dart`.
- `--di` also generates `di/<f>_module.dart`, an injectable `@module`.
- Registers the router in `lib/app/router/<app>_router_module.dart`
  (tool-owned), then runs `dart format` and build_runner.
- `<F>Navigation` lists where the feature can go (`goBack()` to start); it
  has no `goTo<F>()`, because nothing else should import it.
- Next: build the UI in the page, events/states in the bloc, and add
  navigation methods to `<F>Navigation` and its impl.
- To open another feature, add a method to this feature's `<F>Navigation`
  (e.g. `goToCart()`) and implement it in
  `lib/app/navigation/<f>_navigation_impl.dart`. Never import the other
  feature.''',
  ),
  (
    name: 'add-repo',
    usage: 'clean-helper add-repo <feature> <repo_name> [--add-sample] [--no-rest]',
    summary:
        'Adds a repository to a feature: entity, repository interface '
        'and implementation, datasource, and (with the network package) a '
        'Retrofit datasource.',
    whenToUse: 'When a feature needs data from an API or another source.',
    details: '''
- Every layer returns fpdart `TaskEither<Failure, T>`.
- `--add-sample` adds sample `get`/`post` methods at every layer, request and
  response models, params and use cases — the quickest way to see the shape.
- REST files (`data/constants/<f>_api_paths.dart`,
  `data/datasources/rest_<r>_data_source.dart`) are generated only when the
  app has `lib/core/network/di/network_config_module.dart` (from
  `add-network-module`). `--no-rest` skips them.
- A second repo in the same feature adds its constant to the existing
  `<f>_api_paths.dart`.
- Next: add methods to the datasource base, `@GET`/`@POST` to the REST
  datasource, fields to the models, and implement the repository.''',
  ),
  (
    name: 'add-entity',
    usage: 'clean-helper add-entity <feature|core> <entity_name> [folder]',
    summary: 'Adds a domain entity and the freezed model implementing it.',
    whenToUse:
        'For a domain type that is not tied to one repository, or a '
        'shared one in `lib/core/`.',
    details: '''
- `<feature>` writes to `lib/features/<f>/`; `core` writes to `lib/core/`.
- Generates `domain/entities/<name>_entity.dart` and
  `data/models/[<folder>/]<name>_model.dart` (`@freezed`, with `fromJson`).''',
  ),
  (
    name: 'add-network-module',
    usage: 'clean-helper add-network-module',
    summary:
        'Creates the network package (unless it exists or has `create: '
        'false`) and wires the app to it.',
    whenToUse:
        'Once, if the app was initialised with `--skip-network` and '
        'now needs an API.',
    details: '''
- App side: `ApiPaths`, `ErrorModel`, `ApiFailure`, the call adapter
  (`lib/core/network/adapters/app_call_adapter.dart`), `AppAuthInterceptor`
  (with `auth_interceptor`), `NetworkConfigModule` and a `@test` stand-in.
- Adds the package module to `di_initializer.dart` and `DioLens.init` to
  `InitService`.''',
  ),
  (
    name: 'remove-feature',
    usage: 'clean-helper remove-feature <feature_name>',
    summary: 'Deletes a feature and unregisters its router.',
    whenToUse:
        'To delete a feature cleanly. Never delete feature folders by '
        'hand — the router module and DI config would point at missing files.',
    details: '''
- Removes the router from `<app>_router_module.dart`, deletes
  `lib/features/<f>/` and its navigation impl, then formats and runs
  build_runner.
- Afterwards, fix the other features' navigation impls in
  `lib/app/navigation/` that pointed at it. Nothing under `lib/features/`
  should need changing; if it does, a feature imported another one.''',
  ),
  (
    name: 'regenerate-router',
    usage: 'clean-helper regenerate-router',
    summary:
        'Rebuilds `lib/app/router/<app>_router_module.dart` from the '
        'feature routers on disk.',
    whenToUse:
        'When the router module is out of sync with the features '
        '(e.g. after a merge conflict).',
    details: '''
- Scans `lib/features/<name>/router/<name>_router.dart`, sorts by name and
  rewrites the module. Never edit the module by hand.''',
  ),
  (
    name: 'build-runner',
    usage: 'clean-helper build-runner [build|clean]',
    summary: 'Runs build_runner in the app.',
    whenToUse:
        'After changing freezed, json_serializable, injectable or '
        'Retrofit annotations.',
    details: '''
- Generated files (`*.g.dart`, `*.freezed.dart`, `*.config.dart`,
  `*.module.dart`) are never edited by hand — change the source and rerun.
- In a workspace, packages with their own micro-modules (utils, network)
  must be built before the app; `bootstrap` does that order for you.''',
  ),
  (
    name: 'generate-localizations',
    usage: 'clean-helper generate-localizations',
    summary: 'Runs slang in the localization package.',
    whenToUse: 'After editing the locale JSON files.',
    details: '''
- Strings live in the localization package's locale files, not in widgets;
  use the generated translations (`locales.…`) or `'key'.tr`.''',
  ),
  (
    name: 'bootstrap',
    usage: 'clean-helper bootstrap',
    summary: '`pub get`, slang, then build_runner in the packages and the app.',
    whenToUse:
        'After a clone or a pull that changed dependencies or '
        'generated inputs.',
    details: '''
- Package steps only run for packages under the foundation folder of the
  app; packages shared at a workspace root are built from there (e.g. melos).''',
  ),
  (
    name: 'create-foundation',
    usage: 'clean-helper create-foundation [--dir=<path>]',
    summary:
        'Creates the configured foundation packages (utils, '
        'localization, router, theme, and network if configured) at the '
        'workspace root.',
    whenToUse:
        'Once, at a monorepo root, before the apps run `init` with '
        '`create: false`.',
    details: '''
- Run from the workspace root. Existing packages are not regenerated, but
  still get set up, so rerunning is safe.''',
  ),
  (
    name: 'list-mono-repo-apps',
    usage: 'clean-helper list-mono-repo-apps',
    summary:
        'Prints the monorepo apps and how every clean-helper config key '
        'resolves.',
    whenToUse:
        'To check package names, the foundation folder or other '
        'config before generating code. Read-only.',
    details: '''
- In a monorepo, other commands need `--scope=<app>` before the command name
  to pick an app without a prompt: `clean-helper --scope=<app> add-feature x`.''',
  ),
];
