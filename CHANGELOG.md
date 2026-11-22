## 3.1.0

- **Feature navigation is outgoing only.** A new feature's `<F>Navigation` has `goBack()` instead of `goTo<F>()`, so no feature has to import another to open it. To open `cart` from `home`, add `goToCart()` to `HomeNavigation` and implement it in `lib/app/navigation/home_navigation_impl.dart`. Existing features are unchanged.
- The AI context (`add-agent-context`) describes the navigation interface as outgoing only.

## 3.0.1

AI context (`add-agent-context`) only; no change to generated code.

- **App features are independent.** New rules: a feature never imports another feature, and can be removed without changing the others.
- **Cross-feature navigation** goes through the feature's own navigation interface. For example, `home` gets `goToCart()` in `HomeNavigation`, implemented in `lib/app/navigation/`.
- **Shared code** moves to `lib/core/` or a package instead of being imported from another feature.
- **Recommended layering:** the root-level `features/` layer is now `modules/`, so it isn't confused with an app's features. Modules may depend on each other.

## 3.0.0

### Breaking

- The `clean-helper.packages:` config key is now **`clean-helper.foundation:`** (`foundation.utils`, `foundation.network.module_name`, `foundation.use_root_analysis`, …). `list-mono-repo-apps` and `add-config` use the new key.
- `create-packages` is now **`create-foundation`**.
- Workspace packages live in **`foundation/`** instead of `packages/`. The new `foundation.dir` key sets the folder, relative to the project (for `create-foundation`, the current directory); `create-foundation --dir` overrides it for one run. `init`, `add-network-module`, `bootstrap`, `generate-localizations` and `tools/bootstrap.dart` all use it.

### Changes

- **New `add-agent-context` command** (and `init --agent-context` / `-a`, off by default) writes context for AI coding tools at the project or workspace root: `.agents/` (rules, architecture with your configured package names, and one file per clean-helper command) plus `AGENTS.md` / `CLAUDE.md` pointers. Existing `AGENTS.md` / `CLAUDE.md` files only get a pointer line appended.
- The utils package no longer depends on the localization package; nothing in it used localization.

## 2.1.0

- **New theme package.** `init` (and `create-packages`) generate `packages/<app>_theme`, configured by `packages.theme` (`name`, `import`, `create`), with adaptive light/dark design tokens:
  - `<Base>ThemeData`, `AdaptiveColor`, the `<Base>Theme` widget and its scope, `ThemeResolver` (system or in-app `ThemeMode`), and `<base>MaterialThemeData` for Material `ThemeData`. `<Base>` is the package name without `_theme`.
  - The app gets `lib/core/theme/app_theme.dart` (`appTheme()`). `MainApp` wraps the app in `<Base>Theme` and passes `theme`, `darkTheme` and `themeMode` to `MaterialApp`.
- **`material_ui` instead of `package:flutter/material.dart`** in every generated file, to avoid deprecated Material APIs. The app, router, utils and theme packages depend on `material_ui`.
- Feature routes use `pageBuilder` with a `MaterialPage` (`key: state.pageKey`).

## 2.0.0

### Breaking: environment-aware DI

- `diInitializer(GetIt instance, {required String environment})` calls `init(environment:)`. `InitService.init({environment})` defaults to `Environment.prod` in release builds and `Environment.dev` otherwise.
- `CoreModule.packageInfo` and `NetworkConfigModule.networkConfig` are tagged `@dev` / `@prod`.
- New `@test` stand-ins: `lib/core/di/test_environment_core_module.dart` (a fixed `PackageInfo`) and, with the network package, `lib/core/network/di/test_environment_network_config_module.dart` (`NetworkConfig` with base URL `http://localhost/`).
- Existing projects must pass an environment to `diInitializer`, for example by regenerating `init_service.dart`.

## 1.9.1

- The network package's `BaseOptions` is registered as `@Named(NetworkDIKeys.baseOptions)` (`'<networkCamel>BaseOptions'`), so apps can register their own unnamed `BaseOptions`.
- New `@Named(NetworkDIKeys.noBaseOptionsDio)` Dio without `BaseOptions`, generated with or without `auth_interceptor`. `NetworkDIKeys` is now always generated and exported.
- Dio Lens names the extra Dios after their DI keys (`noAuthDio`, `noBaseOptionsDio`) instead of `no-auth`.

## 1.9.0

### Breaking: API errors are handled by the app's call adapter

- The app gets `AppCallAdapter` (`lib/core/network/adapters/`), which turns every Retrofit call into `TaskEither<Failure, T>`. HTTP errors become `ApiFailure` (`lib/core/network/failures/`), carrying the status code and the backend's `ErrorModel`. `ErrorModel` has `tryParse`, and no longer implements `ErrorEntity`.
- Removed `ErrorInterceptor`, `AppErrorInterceptor`, `ErrorEntity` and the utils package's call adapter. The utils package no longer depends on `retrofit`, and `safeCast` no longer handles error bodies.
- The network package no longer depends on the utils package. `RetrofitLogger` logs through `dart:developer`.
- `call_adapter_name` moves from `packages.utils` to `packages.network`, default `AppCallAdapter`.
- Generated use cases take `{required this._<name>Repository}`.
- `Failure.fromError(e)` keeps a `Failure` as-is and wraps anything else. `leftFromError`, `safeCast` and `safeExecuteTask` use it instead of repeating the check.

## 1.8.1

- A monorepo workspace root must not have a `lib/` folder. A folder with `lib/` is treated as a single app even when its pubspec declares `mono_repo_apps`, so a root made with `flutter create` gets scaffolded as an app. The README's Monorepos section now says so.

## 1.8.0

### Breaking

- `init` generates the network package and the home feature's DI module by default. `--skip-network` (`-n`) and `--skip-di` (`-d`) turn them off; the old `--network` and `--di` flags are gone. `--tools` (`-t`) still adds `tools/`, off by default.
- `tools/` is never generated in a monorepo app (by `init` or `generate-tools`); the workspace root runs those jobs.

## 1.7.0

### Breaking

- **Network is a workspace package.** `add-network-module` and `init --network` create `packages/<app>_network` and wire the app to it. The in-app `NetworkModule`, `lib/core/network/utils/` and the app's `DIKeys` are gone.
- **`add-auth-interceptor` and `init --auth-interceptor` are removed.** Auth is now part of the network package (`packages.network.auth_interceptor`, default `true`).
- **The call adapter lives in the utils package** (`lib/src/network/retrofit_call_adapter.dart`). The utils package now depends on `retrofit`.
- **`UseCaseBase` lives in the utils package** instead of `lib/core/domain/use_cases/`.
- **App router files are named after the app:** `<app>_router.dart` (`<AppPascal>Router`), `<app>_router_redirect.dart` and `<app>_router_module.dart` (`<AppPascal>RouterModule`). They replace `app_go_router.dart` / `AppGoRouter` and `AppRouterModule`.
- **Router package files and classes are named after the package:** `<name>_base.dart` / `<NamePascal>Base` and `<name>_refresh.dart` / `<NamePascal>Refresh`. The default `clean_router` keeps `CleanRouterBase` and `CleanRouterRefresh`.
- **No backward compatibility.** Code that adapted output to projects from older versions is removed:
  - `result_type` / `future_either` (always `TaskEither`)
  - `retrofit_call_adapter` (use `packages.utils.call_adapter_name`)
  - the Chucker variant, and required-context navigation
- **Removed:** the per-command scripts in `bin/` (use `clean-helper <command>`), `add-vscode-config`, and `.vscode/` generation in `init`.

### New commands

- `create-packages [--dir=<path>]`: creates the configured workspace packages (e.g. at a monorepo root) and lists them under `workspace:`.
- `add-config`: adds a commented `clean-helper:` block with every config key to `pubspec.yaml`.
- `add-melos-config`: adds melos with bootstrap and clean hooks and scripts. The bootstrap hook installs clean_helper from pub.dev at the current version.
- `add-vscode-extensions`: adds recommended extensions to `.vscode/extensions.json`, merging with an existing file.

### Configuration

- `packages.utils`, `localization`, `router` and `network` each take `name`, `import` and `create`.
  - With `create: false`, the package is used from the workspace instead of being generated.
  - When nothing is created, the app gets no `workspace:` key.
- `packages.utils.module_name` and `call_adapter_name`, and `packages.network.module_name` and `auth_interceptor`.
- Any other key under `packages.localization` is written to `slang.yaml`.
- `packages.use_root_analysis` (default `true`): monorepo apps and their packages include the workspace root's `analysis_options.yaml`.
- `packages.overwrite_analysis_options` (default `true`): generated `analysis_options.yaml` files replace existing ones.

### Changes

- Workspace packages are added as dependencies without `path:`.
- Package `analysis_options.yaml` files only `include:` the shared rules. Generated rules also exclude `build/`, `android/`, `ios/` and `web/`.
- The network package has abstract `ErrorInterceptor` and `AuthInterceptor` classes and a `@freezed` `NetworkConfig`. Each app implements `AppErrorInterceptor` (with its own `ErrorModel`) and `AppAuthInterceptor`.
- `remove-feature` runs format and build_runner afterwards.
- `create-packages` finishes setting up packages that already exist, so rerunning completes an interrupted run.
- `fvm use` is skipped in monorepo apps (`init`, `bootstrap`, `tools/` scripts).
- `add-feature` refuses a feature named after the app.
- Usage errors share one `❌` message format and exit with code 1.

### Fixes

- A failing external command (`flutter create`, pub, build_runner, slang, format) now stops with its output instead of crashing later.
- `flutter create` works inside a workspace with missing members or no `packages/` folder yet, and stale `workspace:` entries are reported.
- `generate-localizations` and `tools/bootstrap.dart` run slang in the localization package.
- `bootstrap` and `tools/bootstrap.dart` run build_runner in the packages before the app.
- A second `add-repo` in a feature adds its constant to the existing `<feature>_api_paths.dart`.
- `create: false` applies even when the package keeps its default name.
- Nested commands (`init --network`) keep the root config in a monorepo.

## 1.6.1

- README examples use a generic `my_app` package prefix instead of a project-specific name

## 1.6.0

- The utils package gets `ContextUtils` (root navigator and context, theme, media query, focus, snackbar, dialog, bottom sheet, clipboard, haptics and system UI helpers) and its own `di/di_container.dart` (`GetIt.instance`); it now depends on `get_it` and exports `context_utils.dart`
- Generated navigation takes an optional context: `goTo<Feature>([BuildContext? context])` falls back to `ContextUtils.currentContext` and logs through `AppLogger.error` when no context is available. `add-feature` keeps the required-context shape when the utils package has no `lib/src/context_utils.dart`

## 1.5.1

- Each `DioLensInterceptor` is named — `api` for the main `Dio`, `no-auth` for `noAuthDio` — so Dio Lens labels requests by client and replays them through the right one
- `add-auth-interceptor` inserts its `auth_interceptor.dart` and `di_keys.dart` imports in sorted order instead of after the last import, so `directives_ordering` passes

## 1.5.0

- `init` generates `lib/app/init_service.dart`: `InitService.init()` sets the device locale, `Debouncer.showLogs`, runs `diInitializer` and sets `Bloc.observer`, logging any exception through `AppLogger.error`. `bootstrap()` now only calls `WidgetsFlutterBinding.ensureInitialized()`, `await InitService().init()` and `runApp`
- `add-network-module` replaces Chucker and `pretty_dio_logger` with [dio_lens](https://pub.dev/packages/dio_lens): it installs `dio_lens` instead of the two git dependencies, the generated `NetworkModule` adds `DioLensInterceptor(dio: dio)` to `Dio`, and `DioLens.init` (DI navigator key, `themeMode: .system`) is added to `InitService.init` after `Bloc.observer`. `AppGoRouter` is no longer patched with a Chucker observer
- `add-auth-interceptor`'s `noAuthDio` uses its own `DioLensInterceptor`. Network modules generated before 1.5.0 (still on Chucker) get the old `noAuthDio`, and `DioLens.init` goes into `bootstrap.dart` when there is no `init_service.dart`

## 1.4.4

- `RetrofitCallAdapter` and `RetrofitLogger` are now generated by `add-network-module` in the app's `lib/core/network/utils/` instead of the utils package (`packages/<app>_utils/lib/src/network/`). The utils package no longer exports them or depends on `dio` / `retrofit`
- `NetworkModule` and generated REST datasources import them by relative path. With no `retrofit_call_adapter` or `packages.network` config, `add-repo` imports the adapter from `lib/core/network/utils/` when it exists
- Projects initialised before 1.4.4 keep their helpers in the utils package: `add-network-module` detects `packages/<app>_utils/lib/src/network/retrofit_call_adapter.dart` and neither generates the core copies nor changes where `NetworkModule` imports `RetrofitLogger` from
- Rewrite README and `.agents/` docs to match the current behaviour, including configuration, upgrade notes and known issues

## 1.4.3

- `UseCaseBase.call` now returns `FutureOr<TaskEither<Failure, ReturnType>>`, so a use case can do async work before building its `TaskEither`. Generated use cases still return `TaskEither` directly (a valid override); code calling through the `UseCaseBase` type awaits first: `await (await useCase(params)).run()`

## 1.4.2

- `add-repo` now generates fpdart `TaskEither<Failure, T>` across the API chain — datasource, repository and use case — instead of `Future<Either<Failure, T>>` / `FutureOr<Either<…>>`. A `TaskEither` is lazy: call `.run()` to execute it (`await useCase(params).run()`)
- `init` generates a `RetrofitCallAdapter` that adapts to `TaskEither<Failure, T>`, a `UseCaseBase` whose `call` returns `TaskEither`, and a new lazy `safeExecuteTask` helper in the utils package (`safeExecute` is unchanged)
- Add `clean-helper.result_type` (`task_either` default, `future_either`). Projects initialised before 1.4.2 still have a `Future<Either>` call adapter and `UseCaseBase` — set `result_type: future_either` to keep generating compatible code
- `list-mono-repo-apps` prints the result type

## 1.4.1

- Add global `--version` flag that prints the tool version
- The generated `NetworkModule` now registers `RetrofitLogger` as `ParseErrorLogger` (moved from the utils package's DI module). `add-network-module` skips it when an older utils module already registers one
- Add optional `clean-helper.retrofit_call_adapter` config (`name`, `import`) for the call adapter used by generated REST datasources
- `add-repo` now marks the REST datasource's `errorLogger` `@ignoreParam` when `packages.network` is configured (previously keyed on `packages.utils`)
- `add-network-module` uses the configured `packages.utils` import
- Generated files import `package:retrofit/retrofit.dart` instead of `retrofit/error_logger.dart` + `retrofit/http.dart`

## 1.4.0

- Add optional `clean-helper.packages` config (`utils`, `network`) for monorepos whose shared code lives in separately named workspace packages; read from the starting directory before switching into the app
- `add-repo` imports the configured utils package instead of `<app>_utils`, and skips the `core/domain/use_cases/use_case_base.dart` import in use cases when utils is configured
- `add-repo` treats a configured `packages.network` as a network module, so the REST datasource and API paths are generated; the datasource imports the network barrel for `RetrofitCallAdapter`
- REST datasource marks `errorLogger` `@ignoreParam` when utils is configured, since injectable would otherwise resolve an unregistered `ParseErrorLogger` and throw at runtime
- `add-repo` warns when the app's pubspec lacks `dio`, `retrofit` or `retrofit_generator`
- `list-mono-repo-apps` prints the resolved package config
- Fix multi-word feature and repo names producing snake_case identifiers — `sign_up` now generates `SignUpRoutes.signUp` (path stays `/sign-up`), `HomeApiPaths.userAccount`, `userAccountRepository`
- Feature blocs are now `@injectable` instead of `@lazySingleton` — `BlocProvider` closes the bloc on dispose, so a singleton came back closed on the next visit
- `app_router_module.dart` is always sorted alphabetically, regardless of which command wrote it
- Sort package imports in generated router, repository, datasource and use case files so `directives_ordering` passes
- README: document `presentation/page_providers/` instead of the old `presentation/screens/`

## 1.3.1

- Remove redundant `final` modifier from the `list` parameter in the generated `listToModelList` helper

## 1.3.0

- Shared utilities, network helpers, and DI are now generated in a separate `packages/<app>_utils` workspace package instead of `lib/core/`
- Localization config, locale assets, and string extension are now generated in a separate `packages/<app>_localization` workspace package
- Both packages are added to the root `pubspec.yaml` `workspace:` block alongside `clean_router`

## 1.2.2

- Add use case generation to `add-repo --add-sample`: generates `Get{Name}UseCase` and `Post{Name}UseCase` in `domain/use_cases/`, and `Get{Name}Params` / `Post{Name}Params` in `domain/params/`
- Use case params use typed fields: `get{Name}Query` (String) for get, `post{Name}Param1` (String) for post
- Domain repository sample methods now accept params: `get{Name}(Get{Name}Params)` / `post{Name}(Post{Name}Params)`
- Data source base `get` method now takes `String? q` instead of no args
- REST data source `get` method now annotated with `@Query('q')`
- Repository impl maps params to data layer: `params.get{Name}Query` → datasource `q`, `params.post{Name}Param1` → request model `p1`
- Request model gains a sample `{String? p1}` constructor field

## 1.2.1

- Rename `Screen` → `PageProvider` — generated widget class is now `${Feature}PageProvider`, folder moves from `presentation/screens/` to `presentation/page_providers/`, file renamed from `${feature}_screen.dart` to `${feature}_page_provider.dart`

## 1.2.0

- Write `analysis_options.yaml` as the first step in `init`, before directory creation or any `flutter pub add` calls
- Run `flutter pub get` immediately after `analysis_options.yaml` is written and before adding dependencies
- Sort `dependencies` and `dev_dependencies` alphabetically after all packages are added (`sortPubspecDeps`)
- Stamp `clean-helper.version: <version>` in the project's `pubspec.yaml` at the end of `init`, merged into the existing `clean-helper:` section alongside `mono_repo_apps` if present
- Warn on version mismatch — every command now checks `clean-helper.version` in `pubspec.yaml` against the running tool version and prints a warning on stderr if they differ
- Rename `CleanCallAdapter` → `RetrofitCallAdapter`; generated file moves to `lib/core/network/utils/retrofit_call_adapter.dart`
- Fix kebab-case in CLI usage strings (`<feature-name>`, `<repo-name>`, `--scope=<app-name>`)
- Fix next-steps message printed after `init` (`add_feature` → `add-feature`)

## 1.1.5

- Add `--add-sample` flag to `add_repo` command
- When `--add-sample` is passed, generate `get`/`post` sample methods in the domain repo, data source base, repository impl, and REST data source, and create request/response model files
- Without `--add-sample` (default), all files are generated as empty scaffolds and request/response model files are skipped
- Rename all CLI command names from `snake_case` to `kebab-case` (e.g. `add_feature` → `add-feature`, `build_runner` → `build-runner`, etc.)
- Rename `--no_rest` flag to `--no-rest` on `add-repo` command for consistency

## 1.1.4

- Move `retrofit_logger.dart` to `lib/core/network/utils/` and update its `app_logger` import path
- Add `CleanCallAdapter` — a Retrofit `CallAdapter` that wraps responses in `Either<Failure, T>` via `safeExecute`
- Generate `CleanCallAdapter` during `init` network setup
- Update `rest_data_source_template` to use `@RestApi(callAdapter: CleanCallAdapter)` and return `Either<Failure, T>`
- Update `data_source_base_template` to return `Either<Failure, T>` on all methods
- Remove `safeExecute` from `data_repo_template` — repository now delegates directly to the data source

## 1.1.3

- Fix `AppBlocObserver` import path for `app_logger.dart` to `../../core/utils/app_logger.dart`

## 1.1.2

- Remove duplicate `Logger` registration from `AppModule` template (kept in `CoreModule`)
- Drop `--delete-conflicting-outputs` flag from all `build_runner` invocations (removed in latest build_runner)

## 1.1.1

- Replace `dart:developer` `log()` with `AppLogger` across BlocObserver, safe_execute, safe_cast, and get_current_function_name templates
- Use static error messages instead of dynamic function names in error logging
- Replace `BlocObserver` DI registration with `Logger` singleton in AppModule template

## 1.1.0

Update Readme

## 1.0.0

- Initial version.
