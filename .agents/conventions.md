# Code Conventions

## One Function Definition Per File

Every `.dart` file under `lib/src/` contains exactly **one** public function definition.
A file may import and call other functions freely, but must never define additional ones.

```
✅ correct — imports and calls other functions
void generateCoreFiles(String packageName) {
  writeFile(...);          // imported from shared/write_file.dart
  overwriteFile(...);      // imported from shared/write_file.dart
  analysisOptionsTemplate(); // imported from templates/
}

❌ wrong — two definitions in one file
void generateCoreFiles(...) { ... }
void generateNetworkFiles(...) { ... }  // must be a separate file
```

---

## Command Files

Files in `lib/src/commands/` contain **exactly one function** — the command entry point.
All logic lives in `lib/src/functions/`.

---

## writeFile vs overwriteFile

Both are exported from `lib/src/functions/shared/write_file.dart`.

| Function | Behaviour | When to use |
|----------|-----------|-------------|
| `writeFile(path, content)` | Skips if file already exists, logs skip | User-editable files — never stomp on their work |
| `overwriteFile(path, content)` | Always writes, logs the write | Tool-owned generated files (e.g. `analysis_options.yaml`, `router_module.dart`) |

---

## String Case Helpers

All in `lib/src/functions/shared/`:

| File | Function | Input → Output |
|------|----------|----------------|
| `pascal_case.dart` | `pascalCase(input)` | `my_feature` → `MyFeature` |
| `camel_case.dart` | `camelCase(input)` | `my_feature` → `myFeature` |
| `kebab_case.dart` | `kebabCase(input)` | `my_feature` → `my-feature` |

---

## ensurePubspec & abort

Every command starts with `ensurePubspec()`.
It calls `abort(message)` if `pubspec.yaml` is not found in the current directory.
`abort()` has return type `Never` — it prints to stderr and calls `exit(1)`.

---

## All Paths Are Relative to the Target Flutter Project

This tool is run **from inside a Flutter project root**, not from inside `clean_helpers/`.
All file paths in `writeFile`, `Directory.createSync`, etc. are relative to the user's project CWD.

---

## Import Paths

- Shared utilities: `../shared/<file>.dart`
- Init helpers: relative sibling imports within `init/`
- Templates: `templates/<file>.dart` (relative from within `init/`)
- Feature/repo/entity helpers: relative sibling imports within their folder
