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
4. `installNetworkDependencies()` — `dio`, `dio_lens`, `retrofit`, `json_annotation`; dev `retrofit_generator`, `json_serializable`
5. `patchDioLensInit()` — inserts `DioLens.init(navigatorKey: diContainer(), settings: const DioLensSettings(themeMode: .system))` (`dio_lens_init` template) after the `Bloc.observer = diContainer();` line of `lib/app/init_service.dart`, falling back to `lib/app/bootstrap.dart` for projects before 1.5.0, and adds the `dio_lens` import at its sorted place. Skips if `DioLens.init(` is already there; warns if the anchor line is missing
6. `runDartFormat()`, `runBuildRunner()` (unless `runBuildRunnerAfter: false`)

## Generated files

| File | Template | Notes |
|---|---|---|
| `lib/core/network/constants/api_paths.dart` | `core_api_paths` | `ApiPaths.baseUrl` |
| `lib/core/data/models/error_model.dart` | `error_model(utilsImport)` | `@freezed`, implements `ErrorEntity` |
| `lib/core/network/interceptors/error_interceptor.dart` | `error_interceptor` | |
| `lib/core/network/utils/retrofit_call_adapter.dart` | `retrofit_call_adapter(utilsImport)` | skipped when `retrofitHelpersInUtils` |
| `lib/core/network/utils/retrofit_logger.dart` | `retrofit_logger(utilsImport)` | skipped when `retrofitHelpersInUtils` |
| `lib/core/network/di/network_module.dart` | `network_module(loggerImport, registerErrorLogger:)` — `Dio` built in a block body so `DioLensInterceptor(dio: dio, name: 'api')` can take the instance; the name labels its requests in Dio Lens and picks the Dio used to replay them | `loggerImport` is `../utils/retrofit_logger.dart`, or `utilsImport` when `retrofitHelpersInUtils` |

## Compatibility with older projects

| Helper | Detects | Effect |
|---|---|---|
| `utilsRegistersErrorLogger(utils)` | `packages/<utils>/lib/src/di/<utils>_module.dart` mentions `ParseErrorLogger` (before 1.4.1) | `NetworkModule` doesn't register `RetrofitLogger` again — GetIt throws on duplicates |
| `utilsHasRetrofitHelpers(utils)` | `packages/<utils>/lib/src/network/retrofit_call_adapter.dart` exists (before 1.4.4) | No copies in `lib/core/network/utils/`; `NetworkModule` imports `RetrofitLogger` from the utils package |

## Notes

- Projects before 1.5.0 keep their Chucker / `PrettyDioLogger` network module and `app_go_router.dart` (`writeFile` skips them); `add-network-module` no longer installs either package.

- `add-auth-interceptor` patches the generated `NetworkModule` by regex (`@lazySingleton\s+Dio dio\(`). Keep that signature stable.
- `commands/add_network.dart` (`addNetwork()`) is a legacy variant without `patchDioLensInit` or build_runner, and it isn't registered. Keep its arguments in step with `generateNetworkFiles`.
