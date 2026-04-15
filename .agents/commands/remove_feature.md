# Command: remove_feature

**Entry point:** `lib/src/commands/remove_feature.dart` → `removeFeature(List<String> args)`
**Binary:** `dart run bin/remove_feature.dart <feature_name>`

---

## Usage

```bash
clean-helper remove_feature auth
clean-helper remove_feature user_profile
```

Feature name is lowercased automatically. Aborts with an error if no name is provided.

---

## What It Does (in order)

1. `unpatchRouterModule(feature)` — removes the feature's router from `lib/app/router/app_router_module.dart`
2. `deleteFeatureFiles(feature)` — deletes the feature directory and its navigation impl

---

## unpatchRouterModule

- Reads `lib/app/router/app_router_module.dart` and checks for the feature's import line
- If the import is not present, logs `⏭  Router for "<feature>" not registered, skipping` and returns
- Otherwise, parses all remaining feature router imports, filters out the target feature, and regenerates `app_router_module.dart` from scratch using `buildRouterModule(remainingFeatures)`
- Writes via `overwriteFile` — `app_router_module.dart` is fully tool-owned

## deleteFeatureFiles

Deletes:
- `lib/features/<feature>/` (recursive)
- `lib/app/navigations/<feature>_navigation_impl.dart`

Warns (but does not abort) if either path does not exist.

---

## Notes

- No `dart format` or `build_runner` run automatically — run them manually afterwards if needed.
- The command does **not** remove feature-specific DI modules (`di/<feature>_module.dart`) if they exist inside the feature folder — these are deleted as part of the recursive directory delete.
- If `app_router_module.dart` does not exist, router deregistration is skipped with a warning.
- Safe to run on a feature that was partially deleted manually — it will clean up what remains.
