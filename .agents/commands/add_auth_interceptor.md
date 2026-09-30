# Command: add-auth-interceptor

**Entry point:** `lib/src/commands/add_auth_interceptor.dart` → `addAuthInterceptor({runBuildRunnerAfter, showNextSteps})`
**Runner:** `AddAuthInterceptorCommand`. Also called by `init --auth-interceptor`.

## Usage

```bash
clean-helper add-auth-interceptor
```

Run after `add-network-module`. It's idempotent: each step skips work that's already done.

## Flow

1. `ensurePubspec()`
2. `generateAuthInterceptor()` → `lib/core/network/interceptors/auth_interceptor.dart` (`auth_interceptor` template)
3. `patchDiKeys()` → adds `static const String noAuthDio = 'noAuthDio';` to `DIKeys` in `lib/core/di/di_keys.dart`, or creates the file from `di_keys_no_auth`
4. `patchNetworkModule()` → in `lib/core/network/di/network_module.dart`:
   - imports `../interceptors/auth_interceptor.dart` and `../../di/di_keys.dart` (via `insertAfterLastImport`);
   - adds an `AuthInterceptor authInterceptor` parameter to `dio()` and puts it first in the interceptor list;
   - appends a `@Named(DIKeys.noAuthDio)` `noAuthDio()` provider (`no_auth_dio_method` template).
5. `runDartFormat()`, `runBuildRunner()`, then next steps (unless `showNextSteps: false`)

Each patch is skipped when its marker is already in the file. If `network_module.dart` is missing, the step warns and skips.

## Generated interceptor

- `onRequest` attaches the bearer token (TODO: read it from storage).
- `onError` on 401: refreshes via `_refreshToken()` and retries the original request.
- Concurrent refreshes are de-duplicated with `_isRefreshing` / `_refreshFuture`.
- The refresh call uses the `noAuthDio` instance to avoid loops.
- TODOs cover the refresh endpoint, token persistence, and clearing tokens on failure.
