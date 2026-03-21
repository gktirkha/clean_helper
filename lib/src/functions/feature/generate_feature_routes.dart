import 'dart:io';

import '../shared/kebab_case.dart';
import '../shared/pascal_case.dart';

void generateFeatureRoutes(String feature, String basePath) {
  final className = pascalCase(feature);
  final content =
      '''
sealed class ${className}Routes {
  static const String $feature = '/${kebabCase(feature)}';
}
''';
  File('$basePath/router/${feature}_routes.dart').writeAsStringSync(content);
}
