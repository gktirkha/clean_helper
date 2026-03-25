# Command: add_feature

**Entry point:** `lib/src/commands/add_feature.dart` → `addFeature(List<String> args)`
**Binary:** `dart run bin/add_feature.dart <feature_name>`

---

## Usage

```bash
dart run bin/add_feature.dart auth
dart run bin/add_feature.dart user_profile
```

Feature name must be **snake_case**. It is used as-is for file/directory names and converted to
`PascalCase` / `camelCase` for class names.

---

## What It Generates

Given `dart run bin/add_feature.dart auth`:

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
    ├── di/
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
        └── auth_router.dart           (@lazySingleton, implements RouterBase)
```

---

## Router Registration

The new feature's router is **automatically registered** in `lib/app/router/router_module.dart` by `patchRouterModule(featureName)`. No manual step is required.
