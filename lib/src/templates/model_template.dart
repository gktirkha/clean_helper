String modelTemplate(String className, String name, String entityImport) =>
    '''
import 'package:freezed_annotation/freezed_annotation.dart';

import '$entityImport';

part '${name}_model.freezed.dart';
part '${name}_model.g.dart';

@freezed
sealed class ${className}Model with _\$${className}Model implements ${className}Entity {
  const factory ${className}Model() = _${className}Model;

  factory ${className}Model.fromJson(Map<String, dynamic> json) =>
      _\$${className}ModelFromJson(json);
}
''';
