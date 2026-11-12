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
| `utilsImport` | `resolveUtilsPackage().import` |
| `hasNetworkModule` | `lib/core/network/di/network_config_module.dart` exists (written by `add-network-module`) |
| `generateRest` | `!noRest && hasNetworkModule` |
| call adapter name | `resolveCallAdapterName()` — `packages.network.call_adapter_name` ?? `AppCallAdapter` |

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

## Return types (`--add-sample`)

| Layer | Returns |
|---|---|
| datasource base / REST | `TaskEither<Failure, <R>ResponseModel>` |
| domain repo | `TaskEither<Failure, <R>Entity>` |
| repo impl | same, **not** `async`; returns the datasource's value directly (covariant) |
| use cases | `TaskEither<…>`; `import 'package:fpdart/fpdart.dart' show TaskEither;`, `UseCaseBase` from the utils import; constructor `({required this._<camel>Repository})` |

## Generated-code rules

- Package imports go through `sortImports`. The call adapter is imported relatively from `../../../../core/network/adapters/app_call_adapter.dart`; `Failure` comes from the utils import.
- Multi-word repo names use `camelCase` identifiers: `HomeApiPaths.userAccount`, `userAccountRepository`.
- The factory is `factory Rest<R>DataSource(Dio dio, {ParseErrorLogger? errorLogger})`; the network package registers the logger.
- Retrofit is imported as `package:retrofit/retrofit.dart`.

## Logging

- `--no-rest` → `⏭  Skipping REST datasource and API paths (--no-rest).`
- No `network_config_module.dart` → a `⚠️` line pointing at `add-network-module`.
- No `--add-sample` → `⏭  Skipping request/response models (--add-sample not set).`

## API paths

`generateApiPaths` writes `<f>_api_paths.dart` for the first repo in a feature. For later repos it adds `static const String <camelRepo> = '/api/<kebab-feature>/';` before the class's closing brace, and skips the change if the constant is already there.
