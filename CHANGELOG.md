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
