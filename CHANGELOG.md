## 1.1.5

- Add `--add-sample` flag to `add_repo` command
- When `--add-sample` is passed, generate `get`/`post` sample methods in the domain repo, data source base, repository impl, and REST data source, and create request/response model files
- Without `--add-sample` (default), all files are generated as empty scaffolds and request/response model files are skipped

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
