String responseModelTemplate(String className, String repoName) => '''
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/${repoName}_entity.dart';

part '${repoName}_response_model.freezed.dart';
part '${repoName}_response_model.g.dart';

@freezed
sealed class ${className}ResponseModel with _\$${className}ResponseModel implements ${className}Entity {
  const factory ${className}ResponseModel() = _${className}ResponseModel;

  factory ${className}ResponseModel.fromJson(Map<String, dynamic> json) =>
      _\$${className}ResponseModelFromJson(json);
}
''';
