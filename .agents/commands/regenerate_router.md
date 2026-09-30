# Command: regenerate-router

**Entry point:** `lib/src/commands/regenerate_router.dart` → `regenerateRouter()`
**Runner:** `RegenerateRouterCommand`

## Usage

```bash
clean-helper regenerate-router
```

## Behaviour

1. `ensurePubspec()`
2. Lists the directories in `lib/features/`, keeping each `<name>` that has `lib/features/<name>/router/<name>_router.dart`.
3. Warns and returns if `lib/features/` is missing or no routers are found.
4. `overwriteFile('lib/app/router/app_router_module.dart', buildRouterModule(features))`, then `runDartFormat()`.

`buildRouterModule` (`functions/feature/build_router_module.dart`) sorts the features, then renders `app_router_module_build`. That's the single source of the module's content, shared with `patchRouterModule` and `unpatchRouterModule`, so all three commands produce identical output for the same features.

The generated module injects each `<F>Router` into an `AppGoRouter` factory and sorts the routers at runtime by `priority`.
