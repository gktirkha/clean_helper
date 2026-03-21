# Command: add_repo

**Entry point:** `lib/src/commands/add_repo.dart` → `addRepo(List<String> args)`
**Binary:** `dart run bin/add_repo.dart <feature> <repo_name>`

---

## Usage

```bash
dart run bin/add_repo.dart home invoice
dart run bin/add_repo.dart auth user
```

`<feature>` is the feature name (snake_case). Core scope is **not supported** — use `add_entity` for core models.
`<repo_name>` is snake_case.

---

## What It Generates

`dart run bin/add_repo.dart home invoice` produces:

```
lib/features/home/
├── domain/
│   ├── entities/
│   │   └── invoice_entity.dart                   (abstract class InvoiceEntity)
│   └── repositories/
│       └── invoice_repository.dart               (abstract interface InvoiceRepository)
└── data/
    ├── constants/
    │   └── home_api_paths.dart                   (sealed class HomeApiPaths)
    ├── datasources/
    │   ├── invoice_data_source_base.dart          (abstract interface InvoiceDataSourceBase)
    │   └── rest_invoice_data_source.dart          (@RestApi, @Injectable, Retrofit impl)
    ├── models/
    │   ├── requests/
    │   │   └── invoice_request_model.dart         (@JsonSerializable)
    │   └── response/
    │       └── invoice_response_model.dart        (@freezed, implements InvoiceEntity)
    └── repositories/
        └── invoice_repository_impl.dart           (@Singleton, implements InvoiceRepository)
```

---

## Generated File Contents

**Entity:**
```dart
abstract class InvoiceEntity {}
```

**Domain repository:**
```dart
import '../entities/invoice_entity.dart';

abstract interface class InvoiceRepository {
  Future<InvoiceEntity> getInvoice();
}
```

**API paths:**
```dart
sealed class HomeApiPaths {
  static const String invoice = '/api/home/';
}
```

**Datasource base:**
```dart
import '../models/response/invoice_response_model.dart';

abstract interface class InvoiceDataSourceBase {
  Future<InvoiceResponseModel> getInvoice();
}
```

**REST datasource (Retrofit):**
```dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../constants/home_api_paths.dart';
import '../models/response/invoice_response_model.dart';
import 'invoice_data_source_base.dart';

part 'rest_invoice_data_source.g.dart';

@RestApi()
@Injectable(as: InvoiceDataSourceBase)
abstract class RestInvoiceDataSource implements InvoiceDataSourceBase {
  @factoryMethod
  factory RestInvoiceDataSource(Dio dio, {ParseErrorLogger? errorLogger}) =
      _RestInvoiceDataSource;

  @override
  @GET(HomeApiPaths.invoice)
  Future<InvoiceResponseModel> getInvoice();
}
```

**Request model:**
```dart
import 'package:json_annotation/json_annotation.dart';

part 'invoice_request_model.g.dart';

@JsonSerializable()
class InvoiceRequestModel {
  const InvoiceRequestModel();

  factory InvoiceRequestModel.fromJson(Map<String, dynamic> json) =>
      _$InvoiceRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceRequestModelToJson(this);
}
```

**Response model:**
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/invoice_entity.dart';

part 'invoice_response_model.freezed.dart';
part 'invoice_response_model.g.dart';

@freezed
sealed class InvoiceResponseModel with _$InvoiceResponseModel implements InvoiceEntity {
  const factory InvoiceResponseModel() = _InvoiceResponseModel;

  factory InvoiceResponseModel.fromJson(Map<String, dynamic> json) =>
      _$InvoiceResponseModelFromJson(json);
}
```

**Repository impl:**
```dart
import 'package:injectable/injectable.dart';

import '../../domain/entities/invoice_entity.dart';
import '../../domain/repositories/invoice_repository.dart';
import '../datasources/invoice_data_source_base.dart';

@Singleton(as: InvoiceRepository)
class InvoiceRepositoryImpl implements InvoiceRepository {
  InvoiceRepositoryImpl({required InvoiceDataSourceBase invoiceDataSourceBase})
      : _invoiceDataSourceBase = invoiceDataSourceBase;

  final InvoiceDataSourceBase _invoiceDataSourceBase;

  @override
  Future<InvoiceEntity> getInvoice() => _invoiceDataSourceBase.getInvoice();
}
```

---

## All imports are relative

No `package:` imports are used for internal project files — all cross-file imports within the feature use relative paths.

---

## Next steps after generating

1. Replace the placeholder path in `data/constants/home_api_paths.dart`
2. Add fields to the request/response models and run `build_runner`
3. Add more methods to datasource base, rest datasource, and repository as needed
