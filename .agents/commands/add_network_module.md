# Command: add-network-module

**Entry point:** `lib/src/commands/add_network_module.dart` → `addNetworkModule({runBuildRunnerAfter})`
**Runner:** `AddNetworkModuleCommand`. Also called by `init --network` / `--auth-interceptor`.

## Usage

```bash
clean-helper add-network-module
```

It's idempotent: every file goes through `writeFile`.

## Flow

1. `ensurePubspec()`
2. `utilsPackageName` = `utilsPackageConfig?.name` ?? `<app>_utils`; `utilsImport` = `utilsPackageConfig?.import` ?? `package:<utils>/<utils>.dart`
3. `generateNetworkFiles(utilsImport, registerErrorLogger: !utilsRegistersErrorLogger(utils), retrofitHelpersInUtils: utilsHasRetrofitHelpers(utils))`
4. `installNetworkDependencies()` — `dio`, `retrofit`, `json_annotation`; dev `retrofit_generator`, `json_serializable`; `pretty_dio_logger` from git
5. `addChuckerDependency()` — `chucker_flutter` from git
6. `patchAppGoRouter()` — adds the Chucker import and `observers: [ChuckerFlutter.navigatorObserver]` to `lib/app/router/app_go_router.dart`
7. `runDartFormat()`, `runBuildRunner()` (unless `runBuildRunnerAfter: false`)

## Generated files

| File | Template | Notes |
|---|---|---|
| `lib/core/network/constants/api_paths.dart` | `core_api_paths` | `ApiPaths.baseUrl` |
| `lib/core/data/models/error_model.dart` | `error_model(utilsImport)` | `@freezed`, implements `ErrorEntity` |
| `lib/core/network/interceptors/error_interceptor.dart` | `error_interceptor` | |
| `lib/core/network/utils/retrofit_call_adapter.dart` | `retrofit_call_adapter(utilsImport)` | skipped when `retrofitHelpersInUtils` |
| `lib/core/network/utils/retrofit_logger.dart` | `retrofit_logger(utilsImport)` | skipped when `retrofitHelpersInUtils` |
| `lib/core/network/di/network_module.dart` | `network_module(loggerImport, registerErrorLogger:)` | `loggerImport` is `../utils/retrofit_logger.dart`, or `utilsImport` when `retrofitHelpersInUtils` |

## Compatibility with older projects

| Helper | Detects | Effect |
|---|---|---|
| `utilsRegistersErrorLogger(utils)` | `packages/<utils>/lib/src/di/<utils>_module.dart` mentions `ParseErrorLogger` (before 1.4.1) | `NetworkModule` doesn't register `RetrofitLogger` again — GetIt throws on duplicates |
| `utilsHasRetrofitHelpers(utils)` | `packages/<utils>/lib/src/network/retrofit_call_adapter.dart` exists (before 1.4.4) | No copies in `lib/core/network/utils/`; `NetworkModule` imports `RetrofitLogger` from the utils package |

## Notes

- `add-auth-interceptor` patches the generated `NetworkModule` by regex (`@lazySingleton\s+Dio dio\(`). Keep that signature stable.
- `commands/add_network.dart` (`addNetwork()`) is a legacy variant without `patchAppGoRouter` or build_runner, and it isn't registered. Keep its arguments in step with `generateNetworkFiles`.
