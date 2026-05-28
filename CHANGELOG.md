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
