# Command: generate_localizations

**Entry point:** `lib/src/commands/generate_localizations.dart` → `runGenerateLocalizationsCommand(List<String> args)`
**Binary:** `dart run bin/generate_localizations.dart`

---

## Usage

```bash
clean-helper generate_localizations
# or
dart run bin/generate_localizations.dart
```

No arguments required.

---

## What It Does

Runs `dart run slang` in the current Flutter project to regenerate locale files from source JSON.

- Source: `assets/locales/en.locale.json`
- Output: `lib/core/generated/locales/locales.g.dart`
- Config: `slang.yaml` at project root

---

## When To Use

- After editing any locale JSON files under `assets/locales/`
- When locale generated files are out of sync

---

## Implementation Notes

- Calls `runGenerateLocalizations()` from `lib/src/functions/generate_localizations/run_generate_localizations.dart`
- Validates `pubspec.yaml` exists before running (must be run from Flutter project root)
- Safe to run multiple times (idempotent)
