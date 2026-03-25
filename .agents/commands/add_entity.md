# Command: add_entity

**Entry point:** `lib/src/commands/add_entity.dart` → `addEntity(List<String> args)`
**Binary:** `dart run bin/add_entity.dart <scope> <entity_name> [folder]`

---

## Usage

```bash
# Basic
dart run bin/add_entity.dart home invoice

# With subfolder (places model in data/models/requests/)
dart run bin/add_entity.dart home invoice requests

# In core
dart run bin/add_entity.dart core error
```

`<scope>` is either `core` or a feature name.
`[folder]` is optional — it nests the model inside `data/models/<folder>/`.

---

## What It Generates

**Without folder** (`dart run bin/add_entity.dart home invoice`):

```
lib/features/home/
├── domain/entities/
│   └── invoice_entity.dart            (abstract class InvoiceEntity)
└── data/models/
    └── invoice_model.dart             (@freezed, implements InvoiceEntity)
```

**With folder** (`dart run bin/add_entity.dart home invoice requests`):

```
lib/features/home/
├── domain/entities/
│   └── invoice_entity.dart
└── data/models/requests/
    └── invoice_model.dart
```

---

## Generated File Contents

**Entity:**
```dart
abstract class InvoiceEntity {}
```

**Model (freezed + json_serializable):**
```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/invoice_entity.dart';

part 'invoice_model.freezed.dart';
part 'invoice_model.g.dart';

@freezed
sealed class InvoiceModel with _$InvoiceModel implements InvoiceEntity {
  const factory InvoiceModel() = _InvoiceModel;

  factory InvoiceModel.fromJson(Map<String, dynamic> json) =>
      _$InvoiceModelFromJson(json);
}
```

`build_runner` runs automatically at the end of this command — no manual step needed.
