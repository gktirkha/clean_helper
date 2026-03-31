String featureNavigationTemplate(String className) => '''
import 'package:flutter/material.dart';

abstract class ${className}Navigation {
  void goTo$className(BuildContext context);
}
''';
