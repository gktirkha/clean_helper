# Command: remove-feature

**Entry point:** `lib/src/commands/remove_feature.dart` → `removeFeature(args)`
**Runner:** `RemoveFeatureCommand`

## Usage

```bash
clean-helper remove-feature user_profile
```

The name is lower-cased. It aborts if no name is given.

## Flow

1. `ensurePubspec()`
2. `unpatchRouterModule(f)`:
   - If `lib/app/router/app_router_module.dart` doesn't import the feature's router, it logs `⏭ … not registered` and moves on.
   - Otherwise it rebuilds the file from the remaining feature imports with `buildRouterModule`, which sorts them, using `overwriteFile`.
   - It warns if the file is missing.
3. `deleteFeatureFiles(f)`: deletes `lib/features/<f>/` recursively, and `lib/app/navigation/<f>_navigation_impl.dart`. It warns about, but doesn't abort on, missing paths.

It doesn't run `dart format` or build_runner. Stale DI registrations disappear the next time build_runner runs.
