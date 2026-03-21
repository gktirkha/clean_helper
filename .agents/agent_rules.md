# Rules for AI Agents

These constraints must be respected when modifying or extending this codebase.

---

## File Structure Rules

- **One function definition per file** — everywhere under `lib/src/`.
- **Command files have one function** — never add helpers directly in `lib/src/commands/`.
- **Never export function files** from `lib/clean_helper.dart` — commands only.
- **New helpers go in `lib/src/functions/<group>/`** — create a new file, never add to an existing one.
- **New templates go in `lib/src/functions/init/templates/`** — one template function per file.

---

## File Writing Rules

- Use `writeFile(path, content)` for files the user may edit — skips if file exists.
- Use `overwriteFile(path, content)` only for config files owned by the tool (e.g. `analysis_options.yaml`).
- Never use `File(...).writeAsStringSync(...)` directly from command files — go through the shared helper.

---

## Path Rules

- All generated file paths are **relative to the Flutter project's CWD**, not to `clean_helper/`.
- Do not use `path.join` or absolute paths — keep paths as plain relative strings.

---

## Import Rules

- Shared utilities: import from `../shared/<file>.dart`.
- Do not create circular imports between function files.
- `camel_case.dart` may import `pascal_case.dart` (it depends on it); nothing else may form a cycle.

---

## Naming Rules

- Function files: `snake_case.dart` matching the function name.
- Public functions: `camelCase`, matching the file name in camelCase.
- Template functions: suffix `Template` (e.g. `mainDartTemplate()`).
- Generator functions in `init/`: prefix `generate` or `create` or `run` or `install` or `add`.
- Generator functions in `feature/`: prefix `generateFeature`.

---

## What NOT to Do

- Do not add logic to `bin/` files — they must only call the command function.
- Do not add more than one public function to any `.dart` file under `lib/src/`.
- Do not run `build_runner` or `dart format` from within helper functions — only `runInit()` does this.
- Do not modify files that already exist in the target project without using `overwriteFile`.
