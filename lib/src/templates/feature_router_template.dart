import '../functions/shared/camel_case.dart';
import '../functions/shared/sort_imports.dart';

String featureRouterTemplate(
  String feature,
  String className,
  String routerImport,
  String routerPrefix, {
  String band = 'feature',
}) =>
    '''
import 'dart:async';

${sortImports(["import '$routerImport';", "import 'package:material_ui/material_ui.dart';", "import 'package:go_router/go_router.dart';", "import 'package:injectable/injectable.dart';"])}

import '../presentation/page_providers/${feature}_page_provider.dart';
import '${feature}_routes.dart';

@lazySingleton
class ${className}Router implements ${routerPrefix}Base {
  @override
  List<RouteBase> get routes => [
    GoRoute(
      path: ${className}Routes.${camelCase(feature)},
      pageBuilder: (context, state) =>
          MaterialPage(key: state.pageKey, child: const ${className}PageProvider()),
    ),
  ];

  @override
  List<Stream<dynamic>> get refreshStreams => [];

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) => null;

  @override
  int get priority => ${routerPrefix}Priority.$band;
}
''';
