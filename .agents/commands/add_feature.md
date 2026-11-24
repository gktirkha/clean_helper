# Command: add-feature

**Entry point:** `lib/src/commands/add_feature.dart` → `addFeature(args, {withDi, runBuildRunnerAfter, blocName, withBloc})`
**Runner:** `AddFeatureCommand` — flags `--di` / `-d`, `--bloc-name=<name>`, `--[no-]bloc`

## Usage

```bash
clean-helper add-feature user_profile
clean-helper add-feature user_profile --di
clean-helper add-feature user_profile --bloc-name=profile_page
clean-helper add-feature about --no-bloc
```

The name is lower-cased and should be snake_case. It can't be the app's name: the app's router is `<AppPascal>Router`, which the feature's router would duplicate.

## Flow

1. `ensurePubspec()`
2. `resolveUtilsPackage()` and `resolveRouterPackage()` give the utils import and the router package (its import and `<RouterPascal>Base`)
3. `createFeatureStructure('lib/features/<f>', f, utilsImport, router, withDi:, blocName:, withBloc:)`, which calls `generateFeatureRoutes`, `…Navigation`, `…NavigationImpl`, `…Page`, `…PageProvider(bloc:)`, `…Router` and `generateFeatureBloc(<bloc>)` (the bloc name is `--bloc-name`, else `f`; skipped with `--no-bloc`, and the page provider then has no `BlocProvider`), plus `…Module` with `--di`
4. `patchRouterModule(f)`
5. `runDartFormat()`, `runBuildRunner()`

## Output

```
lib/app/navigation/<f>_navigation_impl.dart                 @LazySingleton(as: <F>Navigation); goBack pops (context ?? ContextUtils.currentContext), else go(HomeRoutes.home) (not in home itself)
lib/features/<f>/router/<f>_routes.dart                      sealed class <F>Routes { static const String <camel> = '/<kebab>'; }
lib/features/<f>/router/<f>_navigation.dart                  abstract class <F>Navigation { void goBack([BuildContext?]) }
lib/features/<f>/router/<f>_router.dart                      @lazySingleton, implements <RouterPascal>Base, priority <RouterPascal>Priority.feature (home: .shell)
lib/features/<f>/presentation/pages/<f>_page.dart            pure UI, takes `navigation`
lib/features/<f>/presentation/page_providers/<f>_page_provider.dart   BlocProvider(create: (_) => diContainer()), <F>Page(navigation: diContainer())
lib/features/<f>/presentation/bloc/<b>/<b>_bloc.dart         @injectable; one on<Event> dispatching with when; <b> = --bloc-name or <f>; none with --no-bloc
lib/features/<f>/di/<f>_module.dart                          --di only
```

- **Identifiers:** `camelCase(f)` for the route constant (`SignUpRoutes.signUp`), `kebabCase(f)` for the path (`/sign-up`), `pascalCase(f)` for classes.
- **Bloc:** `@injectable`, not a singleton, because `BlocProvider` closes the bloc on dispose.
- **Router template imports:** the router package (`foundation.router.import`, default `clean_router`), `flutter`, `go_router`, `injectable` — sorted with `sortImports`.
- **Navigation is outgoing only:** no `goTo<F>()` on the feature's own interface, so no feature needs to import another. Callers may omit the context; the impl falls back to `ContextUtils.currentContext` from the utils package and logs an error if there is none.
- **No empty folders:** `add-feature` doesn't create empty `data/` or `domain/` folders; `add-repo` and `add-entity` create them as needed.

## Router registration

`patchRouterModule(f)` reads the feature imports already in `lib/app/router/<app>_router_module.dart`, adds `f`, and rewrites the file with `buildRouterModule(features)`, which sorts alphabetically. It skips a feature that's already registered, and warns if the file is missing. The file is tool-owned, and `overwriteFile` is used.
