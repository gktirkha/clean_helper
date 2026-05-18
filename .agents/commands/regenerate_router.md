# Command: regenerate-router

**Entry point:** `lib/src/commands/regenerate_router.dart` → `regenerateRouter()`
**Binary:** `dart run bin/regenerate_router.dart`

---

## Usage

```bash
clean-helper regenerate-router
```

No arguments required.

---

## What It Does

Scans `lib/features/` for any feature that has a `router/<feature>_router.dart` file, then
**completely regenerates** `lib/app/router/app_router_module.dart` from scratch with all discovered
routers registered. Runs `dart format` at the end.

Features are sorted alphabetically for deterministic output.

---

## When To Use

- `app_router_module.dart` has drifted out of sync with the actual features on disk
- After manually adding or deleting a feature folder without using the CLI
- As a recovery step if `add-feature` or `remove-feature` left the module in a broken state

---

## Implementation Notes

- Discovery is **filesystem-based**: a feature is included if and only if `lib/features/<name>/router/<name>_router.dart` exists
- Uses `buildRouterModule(List<String> features)` from `lib/src/functions/feature/build_router_module.dart`, which delegates to `appRouterModuleBuildTemplate()` in `lib/src/templates/app_router_module_build_template.dart`
- `buildRouterModule` is the single source of truth for router module content — also used by `patchRouterModule` and `unpatchRouterModule`
- Writes via `overwriteFile` — `app_router_module.dart` is fully tool-owned and never manually edited
- Safe to run multiple times (idempotent)
