import '../functions/shared/camel_case.dart';
import '../functions/shared/sort_imports.dart';

/// `goTo<Feature>` uses the given context, else `ContextUtils.currentContext`
/// (from [utilsImport]), and logs an error if neither is available.
String featureNavigationImplTemplate(
  String feature,
  String className,
  String utilsImport,
) {
  final route = '${className}Routes.${camelCase(feature)}';
  final packageUtils = utilsImport.startsWith('package:');

  return '''
${sortImports(["import 'package:flutter/material.dart';", "import 'package:go_router/go_router.dart';", "import 'package:injectable/injectable.dart';", if (packageUtils) "import '$utilsImport';"])}

${sortImports(["import '../../features/$feature/router/${feature}_navigation.dart';", "import '../../features/$feature/router/${feature}_routes.dart';", if (!packageUtils) "import '$utilsImport';"])}

@LazySingleton(as: ${className}Navigation)
class ${className}NavigationImpl implements ${className}Navigation {
  BuildContext? get _context => ContextUtils.currentContext;

  @override
  void goTo$className([BuildContext? context]) {
    final targetContext = context ?? _context;
    if (targetContext == null) {
      AppLogger.error(
        'Context Not Available at ${className}NavigationImpl.goTo$className()',
        error: 'Context Not Available',
        stackTrace: .current,
        time: .now(),
      );
      return;
    }
    targetContext.go($route);
  }
}
''';
}
