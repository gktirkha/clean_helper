# Command: add-repo

**Entry point:** `lib/src/commands/add_repo.dart` → `addRepo(args, {runBuildRunnerAfter, noRest, addSample})`
**Runner:** `AddRepoCommand` — flags `--no-rest`, `--add-sample`

## Usage

```bash
clean-helper add-repo <feature> <repo_name> [--add-sample] [--no-rest]
```

Feature scope only; use `add-entity core …` for core models. Both names are lower-cased.

## Resolution — at the top of `addRepo`

| Value | Source |
|---|---|
| `utilsImport` | `utilsPackageConfig?.import` ?? `package:<app>_utils/<app>_utils.dart` |
| `taskEither` | `usesTaskEither()` — `result_type`; default `true`; aborts on invalid values |
| `hasNetworkModule` | `networkPackageConfig != null` or `lib/core/network/di/network_module.dart` exists |
| `generateRest` | `!noRest && hasNetworkModule` |
| call adapter name | `retrofitCallAdapterConfig?.name` ?? `RetrofitCallAdapter` |
| `adapterImport` | `retrofitCallAdapterConfig?.import` ?? `networkPackageConfig?.import` ?? `../../../../core/network/utils/retrofit_call_adapter.dart` if that file exists ?? null (the utils import provides it) |
| `ignoreErrorLogger` | `networkPackageConfig != null` |
| `importUseCaseBase` | `utilsPackageConfig == null` |

## Output

```
lib/features/<f>/domain/entities/<r>_entity.dart                  always
lib/features/<f>/domain/repositories/<r>_repository.dart           always (empty interface without --add-sample)
lib/features/<f>/data/datasources/<r>_data_source_base.dart        always (empty interface without --add-sample)
lib/features/<f>/data/repositories/<r>_repository_impl.dart        always — @Singleton(as: <R>Repository)
lib/features/<f>/domain/params/{get,post}_<r>_params.dart          --add-sample
lib/features/<f>/domain/use_cases/{get,post}_<r>_use_case.dart     --add-sample
lib/features/<f>/data/models/requests/<r>_request_model.dart       --add-sample — @JsonSerializable
lib/features/<f>/data/models/response/<r>_response_model.dart      --add-sample — @freezed, implements <R>Entity
lib/features/<f>/data/constants/<f>_api_paths.dart                 REST — static const <camelRepo> = '/api/<kebab-feature>/'
lib/features/<f>/data/datasources/rest_<r>_data_source.dart        REST — @RestApi(callAdapter: …), @Injectable(as: <R>DataSourceBase)
```

After generating REST files, `warnMissingRestDependencies()` warns if the app's pubspec lacks `dio`, `retrofit` or `retrofit_generator`.

## Result types (`--add-sample`)

| Layer | `task_either` (default) | `future_either` |
|---|---|---|
| datasource base / REST | `TaskEither<Failure, <R>ResponseModel>` | `Future<Either<Failure, <R>ResponseModel>>` |
| domain repo | `TaskEither<Failure, <R>Entity>` | `Future<Either<…>>` |
| repo impl | same, **not** `async`; returns the datasource's value directly (covariant) | `async` |
| use cases | `TaskEither<…>`; `import 'package:fpdart/fpdart.dart' show TaskEither;` with no `dart:async` | `FutureOr<Either<…>>`, `show Either`, `dart:async` |

## Generated-code rules

- Package imports go through `sortImports`. A relative adapter import goes in the relative section.
- Multi-word repo names use `camelCase` identifiers: `HomeApiPaths.userAccount`, `userAccountRepository`.
- With `importUseCaseBase: false`, use cases rely on the utils package exporting `UseCaseBase`.
- With `ignoreErrorLogger`, the factory is `factory Rest<R>DataSource(Dio dio, {@ignoreParam ParseErrorLogger? errorLogger})`, with a comment explaining why.
- Retrofit is imported as `package:retrofit/retrofit.dart`.

## Logging

- `--no-rest` → `⏭  Skipping REST datasource and API paths (--no-rest).`
- No network module → a `⚠️` line naming both detection sources.
- No `--add-sample` → `⏭  Skipping request/response models (--add-sample not set).`

## Known issue

Every file uses `writeFile`, so a second repo in the same feature doesn't add its constant to the existing `<f>_api_paths.dart`, and the REST datasource then references a missing constant.
