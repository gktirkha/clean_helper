import '../shared/pascal_case.dart';
import '../shared/write_file.dart';

void generateFeatureNavigation(String feature, String basePath) {
  final className = pascalCase(feature);
  final content =
      '''
import 'package:flutter/material.dart';

abstract class ${className}Navigation {
  void goTo$className(BuildContext context);
}
''';
  writeFile('$basePath/router/${feature}_navigation.dart', content);
}
