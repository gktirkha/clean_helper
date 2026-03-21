# Extending clean_helpers

## Adding a New Command

Follow these steps to add a new command (e.g. `add_use_case`):

### 1. Create helper function files

One function per file under `lib/src/functions/<group>/`:

```
lib/src/functions/use_case/
└── generate_use_case_file.dart    → generateUseCaseFile(dir, name)
```

### 2. Create the command file

`lib/src/commands/add_use_case.dart` — exactly one function:

```dart
import 'dart:io';
import '../functions/shared/ensure_pubspec.dart';
import '../functions/use_case/generate_use_case_file.dart';

void addUseCase(List<String> args) {
  ensurePubspec();
  // validate args ...
  generateUseCaseFile(dir, name);
  stdout.writeln('✅ Use case "$name" generated.');
}
```

### 3. Create the binary entry point

`bin/add_use_case.dart`:

```dart
import 'package:clean_helpers/src/commands/add_use_case.dart';

void main(List<String> arguments) => addUseCase(arguments);
```

### 4. Export from the public API

`lib/clean_helpers.dart`:

```dart
export 'src/commands/add_use_case.dart';
```

### 5. Register the executable (optional)

`pubspec.yaml`:

```yaml
executables:
  add-use-case: add_use_case
```

---

## Adding a New Template

Templates live in `lib/src/functions/init/templates/` and return `String`.
Each template is one file with one function:

```dart
// lib/src/functions/init/templates/my_new_template.dart
String myNewTemplate(String packageName) => '''
// generated content here
''';
```

Then import and call it from the relevant generator function.

---

## Adding a New Shared Utility

Place it in `lib/src/functions/shared/` — one function per file.
Import it wherever needed using a relative `../shared/<file>.dart` path.
Do **not** export it from `lib/clean_helpers.dart`.
