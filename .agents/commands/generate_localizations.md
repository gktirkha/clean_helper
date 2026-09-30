# Command: generate-localizations

**Entry point:** `lib/src/commands/generate_localizations.dart` → `runGenerateLocalizationsCommand(args)`
**Runner:** `GenerateLocalizationsCommand`

## Usage

```bash
clean-helper generate-localizations
```

## Behaviour

`ensurePubspec()`, then `runGenerateLocalizations()`, which streams `[fvm] dart run slang` **in the current (app) directory**.

## Known issue

Since 1.3.0, `slang.yaml` and the locale JSON live in `packages/<app>_localization/` (output: `lib/src/generated/`), so running slang in the app root finds no config. `runSlang(localizationPackageName)` in `functions/init/run_slang.dart`, which `init` and `bootstrap` use, runs in the right directory. Fixing this command means switching it to `runSlang('${readPackageName()}_localization')`.

The default locale keys are `general.languageName` and `general.somethingWentWrong`. `safeCast` in the utils package uses the latter.
