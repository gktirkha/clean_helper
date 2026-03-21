import 'dart:io';

import '../shared/pascal_case.dart';

void generateFeatureNavigation(String feature, String basePath) {
  final className = pascalCase(feature);
  final content =
      '''
import 'package:flutter/material.dart';

abstract class ${className}Navigation {
  void goTo$className(BuildContext context);
}
''';
  File(
    '$basePath/router/${feature}_navigation.dart',
  ).writeAsStringSync(content);
}
