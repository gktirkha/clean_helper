# Command: add_feature

**Entry point:** `lib/src/commands/add_feature.dart` → `addFeature(List<String> args)`
**Binary:** `dart run bin/add_feature.dart <feature_name>`

---

## Usage

```bash
clean-helper add_feature auth
clean-helper add_feature user_profile
clean-helper add_feature auth --di    # also generate DI module
```

Feature name must be **snake_case**. It is used as-is for file/directory names and converted to
`PascalCase` / `camelCase` for class names.

---

## What It Generates

Given `clean-helper add_feature auth`:

```
lib/
├── app/navigations/
│   └── auth_navigation_impl.dart      (@LazySingleton, implements AuthNavigation)
└── features/auth/
    ├── data/
    │   ├── constants/
    │   ├── datasources/
    │   ├── models/
    │   │   ├── requests/
    │   │   └── response/
    │   └── repositories/
    ├── di/                            (only with --di flag)
    │   └── auth_module.dart           (@module abstract class AuthModule)
    ├── domain/
    │   ├── entities/
    │   ├── repositories/
    │   └── use_cases/
    ├── presentation/
    │   ├── bloc/auth/
    │   │   ├── auth_bloc.dart         (@lazySingleton, extends Bloc)
    │   │   ├── auth_event.dart        (part of, @freezed)
    │   │   └── auth_state.dart        (part of, @freezed)
    │   ├── pages/
    │   │   └── auth_page.dart
    │   └── widgets/
    └── router/
        ├── auth_routes.dart           (sealed class AuthRoutes)
        ├── auth_navigation.dart       (abstract class AuthNavigation)
        └── auth_router.dart           (@lazySingleton, implements CleanRouterBase)
```

---

## Router Registration

The new feature's router is **automatically registered** in `lib/app/router/router_module.dart`
by `patchRouterModule(featureName)`. No manual step is required.

`router_module.dart` is fully regenerated (not patched line-by-line) using `buildRouterModule(List<String> features)` from `lib/src/functions/feature/build_router_module.dart`.

---

## Post-generation

`dart format` and `build_runner` run automatically — no manual step needed.
