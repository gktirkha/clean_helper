# Command: add-feature

**Entry point:** `lib/src/commands/add_feature.dart` → `addFeature(args, {withDi, runBuildRunnerAfter})`
**Runner:** `AddFeatureCommand` — flag `--di` / `-d`

## Usage

```bash
clean-helper add-feature user_profile
clean-helper add-feature user_profile --di
```

The name is lower-cased and should be snake_case.

## Flow

1. `ensurePubspec()`
2. `createFeatureStructure('lib/features/<f>', f, withDi:)`, which calls `generateFeatureRoutes`, `…Navigation`, `…NavigationImpl`, `…Page`, `…PageProvider`, `…Router` and `…Bloc`, plus `…Module` with `--di`
3. `patchRouterModule(f)`
4. `runDartFormat()`, `runBuildRunner()`

## Output

```
lib/app/navigation/<f>_navigation_impl.dart                 @LazySingleton(as: <F>Navigation); context.go(<F>Routes.<camel>)
lib/features/<f>/router/<f>_routes.dart                      sealed class <F>Routes { static const String <camel> = '/<kebab>'; }
lib/features/<f>/router/<f>_navigation.dart                  abstract class <F>Navigation { void goTo<F>(BuildContext) }
lib/features/<f>/router/<f>_router.dart                      @lazySingleton, implements CleanRouterBase, priority 10
lib/features/<f>/presentation/pages/<f>_page.dart            pure UI, takes `navigation`
lib/features/<f>/presentation/page_providers/<f>_page_provider.dart   BlocProvider(create: (_) => diContainer()), <F>Page(navigation: diContainer())
lib/features/<f>/presentation/bloc/<f>/<f>_bloc.dart         @injectable; part '<f>_event.dart', '<f>_state.dart', '<f>_bloc.freezed.dart'
lib/features/<f>/di/<f>_module.dart                          --di only
```

- **Identifiers:** `camelCase(f)` for the route constant (`SignUpRoutes.signUp`), `kebabCase(f)` for the path (`/sign-up`), `pascalCase(f)` for classes.
- **Bloc:** `@injectable`, not a singleton, because `BlocProvider` closes the bloc on dispose.
- **Router template imports:** `clean_router`, `flutter`, `go_router`, `injectable` — alphabetical, in one block.
- **No empty folders:** `add-feature` doesn't create empty `data/` or `domain/` folders; `add-repo` and `add-entity` create them as needed.

## Router registration

`patchRouterModule(f)` reads the feature imports already in `lib/app/router/app_router_module.dart`, adds `f`, and rewrites the file with `buildRouterModule(features)`, which sorts alphabetically. It skips a feature that's already registered, and warns if the file is missing. The file is tool-owned, and `overwriteFile` is used.
