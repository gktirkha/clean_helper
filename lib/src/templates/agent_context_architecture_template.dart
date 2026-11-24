import '../functions/agent_context/agent_context_info.dart';

/// `.agents/architecture.md`: where code goes in the generated project, with
/// this project's configured package names. Only what reading the code
/// doesn't show.
String agentContextArchitectureTemplate(AgentContextInfo info) {
  final where = info.apps.isEmpty
      ? '`${info.foundationDir}/` (next to `lib/`)'
      : '`${info.foundationDir}/` at the workspace root';
  return '''
# Architecture

## Where code goes

```
lib/
├── app/          knows every feature: router, navigation impls, DI
├── features/<f>/ router/, presentation/ (+ domain/, data/ from add-repo)
├── shared/<m>/   business modules two+ features use: data/, domain/, presentation/
└── core/         infrastructure only: network, DI, theme
```

Imports point down: `app → features → shared → core`. Inside each module:
`presentation → domain ← data`, and
`page → bloc → use case → repository → datasource`.

## Foundation packages

In $where; they depend on no workspace package.

| Package | Holds |
|---|---|
| `${info.utils}` | `Failure`, `UseCaseBase`, `AppLogger`, `safeExecute`, `safeExecuteTask` |
| `${info.localization}` | slang translations, `String.tr` |
| `${info.router}` | the interface every feature router implements |
| `${info.theme}` | design tokens and the theme widget |
| `${info.network}` | Dio instances, `NetworkConfig`, `RetrofitLogger` |

API errors become `ApiFailure` in the app's call adapter
(`${info.callAdapter}`), not in an interceptor.

## DI environments

`prod` in release builds, `dev` otherwise, `test` in tests. Tests start DI
with `Environment.test`; import injectable with `show Environment`, since its
`@test` clashes with `flutter_test`.

## Monorepo layering

Dependencies point down; modules may also depend on each other.

| Layer | May depend on | Examples |
|---|---|---|
| `foundation/` | no workspace package | theme, utils, network |
| `core/` | `foundation/` only | ui, data |
| `modules/` | anything below, other modules | menu, cart, auth |
| `apps/` | anything below; never another app | consumer, rider |
''';
}
