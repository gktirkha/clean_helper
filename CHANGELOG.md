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
