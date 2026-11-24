import '../functions/shared/sort_imports.dart';

/// `goBack` pops the given context, else `ContextUtils.currentContext` (from
/// [utilsImport]); with nothing to pop it goes home (except in `home`
/// itself). It logs an error if no context is available. Methods that
/// open other features are added here by hand, using their `<F>Routes`.
String featureNavigationImplTemplate(
  String feature,
  String className,
  String utilsImport,
) {
  final packageUtils = utilsImport.startsWith('package:');
  final isHome = feature == 'home';
  final popOrHome = isHome
      ? '    if (targetContext.canPop()) targetContext.pop();'
      : '''    if (targetContext.canPop()) {
      targetContext.pop();
    } else {
      targetContext.go(HomeRoutes.home);
    }''';

  return '''
${sortImports(["import 'package:material_ui/material_ui.dart';", "import 'package:go_router/go_router.dart';", "import 'package:injectable/injectable.dart';", if (packageUtils) "import '$utilsImport';"])}

${sortImports(["import '../../features/$feature/router/${feature}_navigation.dart';", if (!isHome) "import '../../features/home/router/home_routes.dart';", if (!packageUtils) "import '$utilsImport';"])}

@LazySingleton(as: ${className}Navigation)
class ${className}NavigationImpl implements ${className}Navigation {
  BuildContext? get _context => ContextUtils.currentContext;

  @override
  void goBack([BuildContext? context]) {
    final targetContext = context ?? _context;
    if (targetContext == null) {
      AppLogger.error(
        'Context Not Available at ${className}NavigationImpl.goBack()',
        error: 'Context Not Available',
        stackTrace: .current,
        time: .now(),
      );
      return;
    }
$popOrHome
  }
}
''';
}
