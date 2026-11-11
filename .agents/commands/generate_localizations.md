# Command: generate-localizations

**Entry point:** `lib/src/commands/generate_localizations.dart` → `runGenerateLocalizationsCommand()`
**Runner:** `GenerateLocalizationsCommand`

## Usage

```bash
clean-helper generate-localizations
```

## Behaviour

`ensurePubspec()`, then `runSlang(<localization>)` in `packages/<localization>` (`resolveLocalizationPackage()`), where `slang.yaml` lives. Aborts if that folder doesn't exist, because the package then lives elsewhere in the workspace.

The default locale keys are `general.languageName` and `general.somethingWentWrong`. `safeCast` in the utils package uses the latter.
