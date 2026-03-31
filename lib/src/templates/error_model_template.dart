String errorModelTemplate() => '''
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/error_entity.dart';

part 'error_model.freezed.dart';
part 'error_model.g.dart';

@freezed
sealed class ErrorModel with _\$ErrorModel implements ErrorEntity {
  const factory ErrorModel({
    @Default([]) @JsonKey(name: 'errors') List<String> errors,
  }) = _ErrorModel;

  factory ErrorModel.fromJson(Map<String, dynamic> json) =>
      _\$ErrorModelFromJson(json);
}
''';
