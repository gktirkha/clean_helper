String errorModelTemplate(String utilsPackageName) =>
    '''
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:$utilsPackageName/$utilsPackageName.dart';

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
