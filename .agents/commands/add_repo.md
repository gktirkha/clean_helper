# Command: add_repo

**Entry point:** `lib/src/commands/add_repo.dart` → `addRepo(List<String> args)`
**Binary:** `dart run bin/add_repo.dart <scope> <repo_name>`

---

## Usage

```bash
# Inside a feature
dart run bin/add_repo.dart home invoice

# In core
dart run bin/add_repo.dart core user
```

`<scope>` is either `core` or an existing feature name.
`<repo_name>` is snake_case.

---

## What It Generates

**Feature scope** (`dart run bin/add_repo.dart home invoice`):

```
lib/features/home/
├── domain/repositories/
│   └── invoice_repository.dart        (abstract interface InvoiceRepository)
└── data/repositories/
    └── invoice_repository_impl.dart   (@LazySingleton, implements InvoiceRepository)
```

**Core scope** (`dart run bin/add_repo.dart core user`):

```
lib/core/
├── domain/repositories/
│   └── user_repository.dart
└── data/repositories/
    └── user_repository_impl.dart
```

---

## Generated File Contents

**Domain (abstract interface):**
```dart
abstract interface class InvoiceRepository {}
```

**Data (implementation):**
```dart
import 'package:injectable/injectable.dart';
import '../../domain/repositories/invoice_repository.dart';

@LazySingleton(as: InvoiceRepository)
class InvoiceRepositoryImpl implements InvoiceRepository {}
```
