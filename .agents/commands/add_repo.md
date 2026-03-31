# Command: add_repo

**Entry point:** `lib/src/commands/add_repo.dart` → `addRepo(List<String> args)`
**Binary:** `dart run bin/add_repo.dart <feature> <repo_name>`

---

## Usage

```bash
clean-helper add_repo home invoice
clean-helper add_repo auth user
clean-helper add_repo home invoice --no_rest   # skip REST datasource and API paths
```

`<feature>` is the feature name (snake_case). Core scope is **not supported** — use `add_entity` for core models.
`<repo_name>` is snake_case.

`--no_rest` (optional flag) — skips generating the REST datasource (`rest_<repo>_data_source.dart`) and API paths (`<feature>_api_paths.dart`), even if a network module is present.

---

## What It Generates

`clean-helper add_repo home invoice` produces:

```
lib/features/home/
├── domain/
│   ├── entities/
│   │   └── invoice_entity.dart                   (abstract class InvoiceEntity)
│   └── repositories/
│       └── invoice_repository.dart               (abstract interface InvoiceRepository { getInvoice, postInvoice })
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

- Every repo generates both `get` and `post` methods as a starting point. Remove or extend as needed.
- The `postInvoice()` impl in `invoice_repository_impl.dart` includes a `//TODO: Pass Params in InvoiceRepository` comment — the request model is instantiated as `const InvoiceRequestModel()`.
- REST datasource and API paths are skipped if `lib/core/network/di/network_module.dart` is not found, **or** if `--no_rest` is passed.
- When `--no_rest` is used, the skip is logged as `⏭  Skipping REST datasource and API paths (--no_rest).`
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
