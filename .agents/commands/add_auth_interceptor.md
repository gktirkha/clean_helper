# Command: add-auth-interceptor

**Entry point:** `lib/src/commands/add_auth_interceptor.dart` → `addAuthInterceptor()`
**Binary:** `dart run bin/add_auth_interceptor.dart`

---

## Usage

```bash
clean-helper add-auth-interceptor
```

No arguments. Must be run from the Flutter project root after `add-network-module`.
Idempotent — skips files/patches that already exist.

---

## What It Does (in order)

1. `generateAuthInterceptor()` — creates `lib/core/network/interceptors/auth_interceptor.dart`
2. `patchDiKeys()` — adds `noAuthDio` constant to `lib/core/di/di_keys.dart` (creates file if missing)
3. `patchNetworkModule()` — wires `AuthInterceptor` + `noAuthDio` into `lib/core/network/di/network_module.dart`

---

## Generated: auth_interceptor.dart

Template: `lib/src/templates/auth_interceptor_template.dart`

Key behaviour:
- `onRequest` — attaches Bearer token (TODO to implement storage read)
- `onError` — on 401, calls `_refreshToken()`, retries the original request with new token
- `_refreshToken()` — deduplicates concurrent refresh calls using `_isRefreshing` + `_refreshFuture`
- Uses `_dio` (the `noAuthDio` instance) for the refresh call to avoid infinite loops

---

## Patched: di_keys.dart

Template (when creating new): `lib/src/templates/di_keys_no_auth_template.dart`

Inserts `static const String noAuthDio = 'noAuthDio';` into the existing `DIKeys` sealed class,
or creates the file with the constant if it doesn't exist.

---

## Patched: network_module.dart

Template for new method: `lib/src/templates/no_auth_dio_method_template.dart`

- Adds `auth_interceptor.dart` and `di_keys.dart` imports
- Adds `AuthInterceptor authInterceptor` parameter to `dio()`
- Inserts `authInterceptor` as first entry in `dio()`'s interceptors list
- Adds `noAuthDio()` provider annotated `@Named(DIKeys.noAuthDio)` — Dio without AuthInterceptor

---

## Post-generation

`build_runner` runs automatically — no manual step needed.

---

## Next steps

1. Fill in the TODOs in `auth_interceptor.dart`:
   - Read access token from storage in `_addAuthHeader()`
   - POST to token refresh endpoint in `_performRefresh()`
   - Save new tokens to storage
   - Clear tokens on refresh failure
