String featureNavigationImplTemplate(String feature, String className) => '''
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../features/$feature/router/${feature}_navigation.dart';
import '../../features/$feature/router/${feature}_routes.dart';

@LazySingleton(as: ${className}Navigation)
class ${className}NavigationImpl implements ${className}Navigation {
  @override
  void goTo$className(BuildContext context) {
    context.go(${className}Routes.$feature);
  }
}
''';
