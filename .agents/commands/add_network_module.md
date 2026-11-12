# Command: add-network-module

**Entry point:** `lib/src/commands/add_network_module.dart` → `addNetworkModule({runBuildRunnerAfter})`
**Runner:** `AddNetworkModuleCommand`. Also called by `init` unless `--skip-network` (with `runBuildRunnerAfter: false`; `init` runs build_runner itself).

## Usage

```bash
clean-helper add-network-module
```

It's idempotent: package files are only written when the package is created, app files go through `writeFile`, and the patches skip when their marker is present.

## Flow

1. `ensurePubspec()`
2. `network = resolveNetworkPackage()` (default `<app>_network`), `auth = networkAuthInterceptorConfig` (default `true`)
3. If `network.create` and `packages/<network>/pubspec.yaml` doesn't exist: `generateNetworkPackage(network, moduleName: resolveNetworkModuleName(network), auth:)`, then `addPackagesWorkspace(['packages/<network>'])`
4. `writePackageAnalysisOptions(['packages/<network>'])` — the existing package follows `use_root_analysis` / `overwrite_analysis_options` too
5. `generateNetworkAppFiles(network.import, utils.import, callAdapterName: resolveCallAdapterName(), auth:)` — app side, see below
6. `installNetworkDependencies(network.name)` — `flutter pub add <network> dio dio_lens retrofit json_annotation` and `--dev retrofit_generator json_serializable`
7. `patchDiInitializer(network.import, '<NetworkPascal>PackageModule')` — rewrites `externalPackageModulesAfter: [...]` in `lib/app/di/di_initializer.dart` with the module appended (one entry per line) and adds the import via `insertSortedImport`
8. `patchDioLensInit()` — inserts `DioLens.init(...)` (`dio_lens_init` template) after `Bloc.observer = diContainer();` in `lib/app/init_service.dart` and adds the `dio_lens` import
9. `sortPubspecDeps` for a created package, `runDartFormat()`, then (unless `runBuildRunnerAfter: false`) build_runner in `packages/<network>` if it exists, then in the app

## Network package (`generateNetworkPackage`)

`scaffoldPackage` + `patchPackagePubspec` (`network_pubspec_tail`: dio, dio_lens, freezed_annotation, injectable, retrofit; dev build_runner, freezed, injectable_generator — no workspace packages), then:

| File | Template | Notes |
|---|---|---|
| barrel (from `import`) | `network_lib_export(prefix, auth:)` | exports the micro-package module and `NetworkConfig`; with auth also `AuthInterceptor`, `NetworkDIKeys` |
| `lib/src/di/di_initializer.dart` | `micro_package_di_initializer` | → `<NetworkPascal>PackageModule` |
| `lib/src/di/<network>_module.dart` | `network_package_module(moduleName, auth:)` | `BaseOptions` from `NetworkConfig`; `RetrofitLogger` as `ParseErrorLogger`; `Dio` (auth, Dio Lens `'api'`); with auth a `@Named(NetworkDIKeys.noAuthDio)` Dio (Dio Lens `'no-auth'`) |
| `lib/src/models/network_config.dart` | `network_config` | `@freezed`; the app registers one |
| `lib/src/utils/retrofit_logger.dart` | `retrofit_logger(packageName)` | logs via `dart:developer` |
| `lib/src/interceptors/auth_interceptor.dart` | `auth_interceptor` | auth only — abstract; `getAccessToken`, `refreshAccessToken`, `onRefreshFailed`, `shouldRefresh`, header hooks; one shared refresh, one retry via `noAuthDio` |
| `lib/src/network_di_keys.dart` | `network_di_keys` | auth only |

## App side (`generateNetworkAppFiles`)

| File | Template |
|---|---|
| `lib/core/network/constants/api_paths.dart` | `core_api_paths` |
| `lib/core/data/models/error_model.dart` | `error_model` — `@freezed`, `static ErrorModel? tryParse(Object? data)` |
| `lib/core/network/failures/api_failure.dart` | `api_failure(utilsImport)` — `ApiFailure extends Failure` (`statusCode`, `error`) |
| `lib/core/network/adapters/app_call_adapter.dart` | `app_call_adapter(callAdapterName, utilsImport)` — `TaskEither.tryCatch`; `DioException` → `ApiFailure` |
| `lib/core/network/di/network_config_module.dart` | `network_config_module(networkImport, auth:)` — `NetworkConfig` (base URL, `User-Agent` from `PackageInfo`); with auth `AppAuthInterceptor` as `AuthInterceptor` |
| `lib/core/network/interceptors/app_auth_interceptor.dart` | `app_auth_interceptor(networkImport)` — auth only |

`add-repo` treats `network_config_module.dart` as the sign that the app is wired, and only then generates REST datasources.

Errors aren't handled by an interceptor: the app's call adapter turns a failed call into `ApiFailure`, using `ErrorModel.tryParse` on the response body. `add-repo`'s REST datasources use it via `@RestApi(callAdapter: <callAdapterName>)`.
