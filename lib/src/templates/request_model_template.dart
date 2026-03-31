String requestModelTemplate(String className, String repoName) => '''
import 'package:json_annotation/json_annotation.dart';

part '${repoName}_request_model.g.dart';

@JsonSerializable()
class ${className}RequestModel {
  const ${className}RequestModel();

  factory ${className}RequestModel.fromJson(Map<String, dynamic> json) =>
      _\$${className}RequestModelFromJson(json);

  Map<String, dynamic> toJson() => _\$${className}RequestModelToJson(this);
}
''';
