# Command: add_auth_interceptor

**Entry point:** `lib/src/commands/add_auth_interceptor.dart` → `addAuthInterceptor()`
**Binary:** `dart run bin/add_auth_interceptor.dart`

---

## Usage

```bash
clean-helper add_auth_interceptor
```

No arguments. Must be run from the Flutter project root. Idempotent — skips files/patches that already exist.

---

## What It Does

1. **Creates** `lib/core/network/interceptors/auth_interceptor.dart`
2. **Patches** `lib/core/di/di_keys.dart` — adds `noAuthDio` constant
3. **Patches** `lib/core/network/di/network_module.dart`:
   - Adds `AuthInterceptor` and `DIKeys` imports
   - Wires `AuthInterceptor` as the first interceptor in the main `Dio` provider
   - Adds a `noAuthDio` provider (Dio without `AuthInterceptor`, used internally by `AuthInterceptor` for token refresh to prevent infinite loops)

---

## Generated: auth_interceptor.dart

```dart
@lazySingleton
class AuthInterceptor extends Interceptor {
  AuthInterceptor({@Named(DIKeys.noAuthDio) required Dio noAuthDio})
      : _dio = noAuthDio;
  ...
}
```

Key behaviour:
- `onRequest` — attach Bearer token from storage (TODO to implement)
- `onError` — on 401, call `_refreshToken()`, retry the original request with the new token
- `_refreshToken()` — deduplicates concurrent refresh calls using `_isRefreshing` + `_refreshFuture`
- Uses `_dio` (the `noAuthDio` instance) for the refresh call to avoid triggering itself

---

## Patched: di_keys.dart

Inserts `static const String noAuthDio = 'noAuthDio';` into the existing `DIKeys` sealed class, or creates the file if it doesn't exist.

---

## Patched: network_module.dart

- Adds `AuthInterceptor authInterceptor` as a parameter to `dio()`
- Inserts `authInterceptor` as the first entry in `dio()`'s interceptors list
- Adds a new `noAuthDio()` provider annotated `@Named(DIKeys.noAuthDio)` with all interceptors except `AuthInterceptor`

---

## Helper files

| File | Function |
|------|----------|
| `functions/auth_interceptor/generate_auth_interceptor.dart` | `generateAuthInterceptor()` |
| `functions/auth_interceptor/patch_di_keys.dart` | `patchDiKeys()` |
| `functions/auth_interceptor/patch_network_module.dart` | `patchNetworkModule()` |
| `functions/shared/insert_after_last_import.dart` | `insertAfterLastImport()` |

---

## Next steps after generating

1. Fill in the TODOs in `auth_interceptor.dart` (token storage reads/writes, refresh endpoint call)
2. Run `clean-helper build_runner build`
