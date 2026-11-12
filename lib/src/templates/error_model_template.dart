/// `lib/core/data/models/error_model.dart`: the backend's error body, parsed
/// by the call adapter via `tryParse`.
String errorModelTemplate() => r'''
import 'package:freezed_annotation/freezed_annotation.dart';

part 'error_model.freezed.dart';
part 'error_model.g.dart';

@freezed
sealed class ErrorModel with _$ErrorModel {
  const factory ErrorModel({
    @Default([]) @JsonKey(name: 'errors') List<String> errors,
  }) = _ErrorModel;

  factory ErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ErrorModelFromJson(json);

  /// Parses the backend's standard error body, or returns `null` if [data]
  /// is not in that format.
  // TODO: Match this to your backend's error format.
  static ErrorModel? tryParse(Object? data) {
    if (data is! Map<String, dynamic> || data['errors'] is! List) return null;
    return ErrorModel.fromJson(data);
  }
}
''';
