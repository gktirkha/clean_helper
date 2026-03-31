import '../shared/pascal_case.dart';
import '../shared/write_file.dart';

void generateFeatureNavigationImpl(String feature) {
  final className = pascalCase(feature);
  final content =
      '''
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
  writeFile('lib/app/navigations/${feature}_navigation_impl.dart', content);
}
