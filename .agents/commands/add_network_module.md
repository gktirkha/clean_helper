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
2. `resolveUtilsPackage()` gives the utils name and import; `resolveCallAdapterName()` names the generated call adapter class
3. `generateNetworkFiles(utilsImport, callAdapterName: resolveCallAdapterName())`
4. `installNetworkDependencies()` — `dio`, `dio_lens`, `retrofit`, `json_annotation`; dev `retrofit_generator`, `json_serializable`
5. `patchDioLensInit()` — inserts `DioLens.init(navigatorKey: diContainer(), settings: const DioLensSettings(themeMode: .system))` (`dio_lens_init` template) after the `Bloc.observer = diContainer();` line of `lib/app/init_service.dart` and adds the `dio_lens` import at its sorted place. Skips if `DioLens.init(` is already there; warns if the anchor line is missing
6. `runDartFormat()`, `runBuildRunner()` (unless `runBuildRunnerAfter: false`)

## Generated files

| File | Template | Notes |
|---|---|---|
| `lib/core/network/constants/api_paths.dart` | `core_api_paths` | `ApiPaths.baseUrl` |
| `lib/core/data/models/error_model.dart` | `error_model(utilsImport)` | `@freezed`, implements `ErrorEntity` |
| `lib/core/network/interceptors/error_interceptor.dart` | `error_interceptor` | |
| `lib/core/network/utils/retrofit_call_adapter.dart` | `retrofit_call_adapter(utilsImport, className)` — class from `resolveCallAdapterName()` | |
| `lib/core/network/utils/retrofit_logger.dart` | `retrofit_logger(utilsImport)` | |
| `lib/core/network/di/network_module.dart` | `network_module()` — registers `RetrofitLogger` as `ParseErrorLogger`; `Dio` built in a block body so `DioLensInterceptor(dio: dio, name: 'api')` can take the instance; the name labels its requests in Dio Lens and picks the Dio used to replay them | |

## Notes

- `add-auth-interceptor` patches the generated `NetworkModule` by regex (`@lazySingleton\s+Dio dio\(` and `dio.interceptors.addAll([`). Keep those stable.
