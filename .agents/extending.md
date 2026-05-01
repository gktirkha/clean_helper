# Extending clean_helper

## Adding a New Command

Follow these steps to add a new command (e.g. `add_use_case`):

### 1. Create template file(s)

One template per file in `lib/src/templates/`:

```dart
// lib/src/templates/use_case_template.dart
String useCaseTemplate(String className) => '''
import '../repositories/${className.toLowerCase()}_repository.dart';

class Get${className}UseCase {
  // TODO: implement
}
''';
```

### 2. Create helper function file(s)

One function per file under `lib/src/functions/<group>/`:

```
lib/src/functions/use_case/
└── generate_use_case_file.dart    → generateUseCaseFile(dir, name)
```

```dart
import 'dart:io';
import '../shared/pascal_case.dart';
import '../shared/write_file.dart';
import '../../templates/use_case_template.dart';

void generateUseCaseFile(String dir, String name) {
  final className = pascalCase(name);
  final path = '$dir/${name}_use_case.dart';
  writeFile(path, useCaseTemplate(className));
  stdout.writeln('  📄 $path');
}
```

### 3. Create the command file

`lib/src/commands/add_use_case.dart` — exactly one function:

```dart
import 'dart:io';
import '../functions/shared/ensure_pubspec.dart';
import '../functions/use_case/generate_use_case_file.dart';

void addUseCase(List<String> args) {
  ensurePubspec();   // ← always first; this also handles monorepo selection automatically
  // validate args ...
  generateUseCaseFile(dir, name);
  stdout.writeln('✅ Use case "$name" generated.');
}
```

> **Monorepo note:** Calling `ensurePubspec()` as the first statement is all that is required — monorepo detection and project selection happen inside it. No extra code is needed in the command.

### 4. Create the binary entry point

`bin/add_use_case.dart`:

```dart
import 'package:clean_helper/src/commands/add_use_case.dart';

void main(List<String> arguments) => addUseCase(arguments);
```

### 5. Export from the public API

`lib/clean_helper.dart`:

```dart
export 'src/commands/add_use_case.dart';
```

### 6. Register the runner command

Create `lib/src/runner/commands/add_use_case_command.dart` and register in `lib/src/runner/clean_helper_runner.dart`:

```dart
addCommand(AddUseCaseCommand());
```

---

## Adding a New Template

Templates live in `lib/src/templates/` and return `String`.
Each template is one file with one function:

```dart
// lib/src/templates/my_new_template.dart
String myNewTemplate(String packageName) => '''
// generated content here
''';
```

Then import and call it from the relevant generator function:

```dart
import '../../templates/my_new_template.dart';

// inside generator function:
writeFile(path, myNewTemplate(packageName));
```

---

## Adding a New Shared Utility

Place it in `lib/src/functions/shared/` — one function per file.
Import it wherever needed using a relative `../shared/<file>.dart` path.
Do **not** export it from `lib/clean_helper.dart`.

---

## Adding a New Init Step

If you need `init` to generate new files:

1. Create a template in `lib/src/templates/`.
2. Create a generator function in `lib/src/functions/init/`.
3. If the new files go into a directory that doesn't already exist, add the directory to the list in `lib/src/functions/init/create_directories.dart`.
4. Call the generator from `runInit()` in `lib/src/commands/init.dart` at the appropriate step.
