# Command: add-repo

**Entry point:** `lib/src/commands/add_repo.dart` → `addRepo(List<String> args)`
**Binary:** `dart run bin/add_repo.dart <feature> <repo_name>`

---

## Usage

```bash
clean-helper add-repo home invoice
clean-helper add-repo auth user
clean-helper add-repo home invoice --no-rest          # skip REST datasource and API paths
clean-helper add-repo home invoice --add-sample       # generate get/post methods + request/response models
clean-helper add-repo home invoice --no-rest --add-sample
```

`<feature>` is the feature name (snake_case). Core scope is **not supported** — use `add_entity` for core models.
`<repo_name>` is snake_case.

`--no-rest` (optional flag) — skips generating the REST datasource (`rest_<repo>_data_source.dart`) and API paths (`<feature>_api_paths.dart`), even if a network module is present.

`--add-sample` (optional flag) — generates sample `get{Name}()` and `post{Name}()` methods in the domain repo, data source base, repository impl, and REST datasource, creates the request/response model files, and generates `Get{Name}UseCase` and `Post{Name}UseCase` in `domain/use_cases/`. Without this flag, those files are generated as empty scaffolds and the model files and use cases are skipped.

---

## What It Generates

`clean-helper add-repo home invoice` produces:

```
lib/features/home/
├── domain/
│   ├── entities/
│   │   └── invoice_entity.dart                   (abstract class InvoiceEntity)
│   ├── repositories/
│   │   └── invoice_repository.dart               (abstract interface InvoiceRepository { getInvoice, postInvoice })
│   ├── params/                                   (only with --add-sample)
│   │   ├── get_invoice_params.dart               (GetInvoiceParams — sample String field)
│   │   └── post_invoice_params.dart              (PostInvoiceParams — sample String field)
│   └── use_cases/                                (only with --add-sample)
│       ├── get_invoice_use_case.dart             (GetInvoiceUseCase implements UseCaseBase<InvoiceEntity, GetInvoiceParams>)
│       └── post_invoice_use_case.dart            (PostInvoiceUseCase implements UseCaseBase<InvoiceEntity, PostInvoiceParams>)
└── data/
    ├── constants/
    │   └── home_api_paths.dart                   (sealed class HomeApiPaths)
    ├── datasources/
    │   ├── invoice_data_source_base.dart          (abstract interface with get + post methods)
    │   └── rest_invoice_data_source.dart          (@RestApi, @Injectable, Retrofit impl)
    ├── models/
    │   ├── requests/
    │   │   └── invoice_request_model.dart         (@JsonSerializable)
    │   └── response/
    │       └── invoice_response_model.dart        (@freezed, implements InvoiceEntity)
    └── repositories/
        └── invoice_repository_impl.dart           (@Singleton, implements InvoiceRepository)
```

---

## Notes

- Without `--add-sample`, domain repo, data source base, and repo impl are generated as empty scaffolds (no methods), and request/response model files and use cases are skipped.
- With `--add-sample`, both `get` and `post` methods are added as a starting point. Remove or extend as needed. The `postInvoice()` impl instantiates the request model as `const InvoiceRequestModel()`.
- REST datasource and API paths are skipped if there is no network module — neither `lib/core/network/di/network_module.dart` nor `clean-helper.packages.network` — **or** if `--no-rest` is passed.
- The utils import is `utilsPackageConfig.import` when `clean-helper.packages.utils` is set, else `package:<app>_utils/<app>_utils.dart`. Templates take the full import URI (`utilsImport`), not a package name.
- With `packages.utils` set: use cases omit the `core/domain/use_cases/use_case_base.dart` import (the utils package provides `UseCaseBase`), and the REST datasource marks `errorLogger` `@ignoreParam` (injectable would otherwise emit `gh<ParseErrorLogger>()`, which throws when nothing registers it).
- With `packages.network` set, the REST datasource also imports the network barrel (for `RetrofitCallAdapter`).
- After generating the REST datasource, `warnMissingRestDependencies()` warns if the app pubspec lacks `dio`, `retrofit` or `retrofit_generator`.
- Package imports are sorted via `sortImports()` so `directives_ordering` passes for any package name.
- Multi-word repo names become camelCase identifiers (`HomeApiPaths.userAccount`, `userAccountRepository`).
- When `--no-rest` is used, the skip is logged as `⏭  Skipping REST datasource and API paths (--no-rest).`
- When `--add-sample` is not set, model files are skipped and logged as `⏭  Skipping request/response models (--add-sample not set).`
- All imports are relative — no `package:` imports for internal project files.

---

## Post-generation

`dart format` and `build_runner` run automatically — no manual step needed.

---

## Next steps after generating

1. Replace the placeholder path in `data/constants/home_api_paths.dart`
2. Add fields to the request/response models
3. Change `@GET` to `@POST` (or other verbs) in the REST datasource as appropriate
4. Add use cases in `domain/use_cases/`
