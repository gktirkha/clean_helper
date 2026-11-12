## 1.7.0

- `UseCaseBase` moves into the utils package: `init` generates `packages/<app>_utils/lib/src/use_case_base.dart` and exports it from the barrel, instead of `lib/core/domain/use_cases/use_case_base.dart` in the app. Generated use cases get it from the utils import
- `add-repo` keeps importing the app's `use_case_base.dart` when the utils package has no `lib/src/use_case_base.dart` (projects initialised before 1.7.0)
- `init` adds `clean_router`, `<app>_localization` and `<app>_utils` to the app without `path:` — they're workspace members, so pub resolves them from the workspace
- `packages.utils`, `packages.localization` and `packages.router` configure the three workspace packages `init` generates, each with `name`, `import` and `create` (default `true`):
  - `create: false` — `init` doesn't generate the package and assumes it exists elsewhere in the workspace (e.g. a monorepo root). If no package is created, the app's `pubspec.yaml` gets no `workspace:` key
  - `import` — the barrel is written at that path, e.g. `package:x/src/all.dart` → `lib/src/all.dart`
  - `utils.module_name` names the utils `@module` class; `utils.call_adapter_name` names the generated call adapter class
  - every other key under `localization` (`base_locale`, `input_directory`, `output_directory`, `translate_var`, …) goes into the package's `slang.yaml`, and the barrel, `String.tr` and `safeCast` follow `output_directory`, `output_file_name` and `translate_var`
  - `add-feature`, `add-repo`, `add-network-module` and `bootstrap` use the configured names; `bootstrap` skips slang when the localization package isn't under `packages/`; `list-mono-repo-apps` prints the new keys
- New `add-vscode-extensions` command: adds the recommended extensions to `.vscode/extensions.json` in the current directory, creating it or merging the missing IDs into an existing file
- New `add-config` command: appends a `clean-helper:` block with every config key, each commented, to the current `pubspec.yaml`. Explanations are `##` comments and commented-out options a single `#`; active values are the defaults, app-dependent keys are commented out, `version` is stamped, and `mono_repo_apps` is filled from `apps/*/pubspec.yaml`
- Fix: `packages.<key>.create: false` now applies even when the package keeps its default name (no `name`/`import`)
- New `create-packages [--dir=<path>]` command: creates the utils, localization and router packages from `clean-helper.packages` (ignoring `create`) in `<dir>/<name>`, `packages/` by default, and lists them under `workspace:` in the current `pubspec.yaml`. It then runs pub get, slang and build_runner. Existing packages are skipped. Meant for a monorepo root whose apps use `create: false`
- Lint rules are written once: packages' `analysis_options.yaml` is just `include:` of the app's file (or, for `create-packages`, the current directory's, created if missing). In a monorepo app, `packages.use_root_analysis` (default `true`) makes the app and its packages include the workspace root's file instead, which `init` creates if missing
- Generated `analysis_options.yaml` excludes `build/**`, `android/**`, `ios/**` and `web/**` from analysis
- **Breaking:** `clean-helper.retrofit_call_adapter` is removed. Set the class name with `packages.utils.call_adapter_name`. The import is `packages.network.import`, else `lib/core/network/utils/retrofit_call_adapter.dart`
- **Breaking — the network layer is a workspace package.** `packages.network` (`name` default `<app>_network`, `import`, `create`, `module_name`, `auth_interceptor` default `true`) describes it, and `add-network-module` / `init --network` create it in `packages/<name>` unless `create: false`; `create-packages` includes it when `packages.network` is configured:
  - the package is an injectable micro-package with a `@freezed` `NetworkConfig`, the Dio module (`BaseOptions` from `NetworkConfig`, `Dio`, `RetrofitLogger` as `ParseErrorLogger`) and an abstract `ErrorInterceptor` (`parseError` → `ErrorEntity`, `shouldHandle`); with `auth_interceptor`, also an abstract `AuthInterceptor` (token, one shared refresh on 401, one retry), a `@Named(NetworkDIKeys.noAuthDio)` Dio and `NetworkDIKeys`
  - the app gets `ApiPaths`, its own `ErrorModel` and `AppErrorInterceptor`, a `NetworkConfigModule` registering `NetworkConfig`, `AppErrorInterceptor` (and `AppAuthInterceptor` as the `AuthInterceptor`), the package module in `di_initializer.dart`'s `externalPackageModulesAfter`, and `DioLens.init`
  - the call adapter moves to the utils package (`lib/src/network/retrofit_call_adapter.dart`; class from `packages.utils.call_adapter_name`), which now depends on `retrofit`
  - removed: the in-app `NetworkModule`, `lib/core/network/utils/`, the app's `DIKeys`, the `add-auth-interceptor` command and `init --auth-interceptor`
  - `add-repo` generates REST datasources when the app has `lib/core/network/di/network_config_module.dart`; datasources no longer mark `errorLogger` `@ignoreParam`
  - `bootstrap`, `init` and `tools/bootstrap.dart` run build_runner in the network package before the app
- **Breaking — no backward compatibility.** Templates and commands now target only projects generated by this version. Removed:
  - `clean-helper.result_type` / `future_either` — the API chain always returns `TaskEither`
  - detection of utils packages that register `ParseErrorLogger` or contain `RetrofitCallAdapter` / `RetrofitLogger`; `add-network-module` always generates both in `lib/core/network/utils/` and registers the logger
  - the Chucker / `PrettyDioLogger` variant of `noAuthDio`, and the `DioLens.init` fallback to `bootstrap.dart`
  - required-`BuildContext` navigation for utils packages without `ContextUtils`
  - importing `UseCaseBase` from `lib/core/domain/use_cases/`
  - the per-command scripts in `bin/` (use `clean-helper <command>`) and the unregistered `addNetwork()` entry point
  - the README's "Upgrading existing projects" table
  - the `add-vscode-config` command; `init` no longer writes `.vscode/`. Use `add-vscode-extensions` for the extension recommendations
- Fix: `generate-localizations` runs slang in the localization package instead of the app root
- Fix: `bootstrap` and the generated `tools/bootstrap.dart` run build_runner in the utils package before the app; `tools/bootstrap.dart` runs slang in the localization package
- Fix: a second `add-repo` in the same feature adds its constant to the existing `<feature>_api_paths.dart`
- Usage errors from `add-feature`, `add-entity`, `add-repo`, `remove-feature` and `build-runner` exit with code 1 through the same `❌` message, using the hyphenated command names
- `init`, `bootstrap` and the generated `tools/` scripts skip `fvm use` in a monorepo app — the Flutter version is pinned at the workspace root
- The router package's files and classes are named after it: `lib/src/<name>_base.dart` / `<NamePascal>Base` and `lib/src/<name>_refresh.dart` / `<NamePascal>Refresh` (so `food_router` → `FoodRouterBase`, `FoodRouterRefresh`; the default stays `CleanRouterBase` / `CleanRouterRefresh`). `AppGoRouter` and feature routers use the derived names
- `packages.overwrite_analysis_options` (default `true`): `init` and `create-packages` replace existing `analysis_options.yaml` files — the app's, the workspace root's with `use_root_analysis`, and `create-packages`' — with the generated ones; `false` keeps existing files. Previously the root file was never replaced. Both this and `use_root_analysis` also apply to packages that already exist, whose `include:` file `init`, `create-packages` and `add-network-module` rewrite
- The app's router files and classes are named after the app: `lib/app/router/<app>_router.dart` (`<AppPascal>Router`, was `app_go_router.dart` / `AppGoRouter`), `<app>_router_redirect.dart` and `<app>_router_module.dart` (`<AppPascal>RouterModule`, was `AppRouterModule`). `add-feature` refuses a feature named after the app, whose router would clash
- `remove-feature` formats and runs build_runner afterwards, so the generated DI config no longer references the deleted feature
- Fix: a failing external command (`flutter create`, `pub`, build_runner, slang, `dart format`) now stops clean-helper with its output instead of continuing into a crash
- Fix: packages are created with `flutter create --no-pub` after creating their parent folder, so `create-packages` and `init` work inside a workspace whose `workspace:` lists missing members or whose `packages/` folder doesn't exist yet; stale `workspace:` entries are reported
- `create-packages` finishes setup (workspace entry, pub get, slang, build_runner, sorted pubspecs) for packages that already exist, so rerunning completes an interrupted run
- Fix: commands that call other commands (`init --network` → `add-network-module`) no longer reload config from the monorepo app's pubspec after switching into it, which dropped the root `clean-helper.packages` settings
- New `add-melos-config` command: run from the workspace root, it adds `melos` to `dev_dependencies` and appends a `melos:` block to `pubspec.yaml` — `bootstrap` / `clean` hooks and the `autogen`, `autogen_watch`, `localize`, `fluttergen`, `dependency_validator`, `generate_license`, `update_packages` and `use_fvm` scripts. Each step is skipped if already present

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
