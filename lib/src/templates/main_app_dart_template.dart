import '../functions/shared/pascal_case.dart';
import '../functions/shared/sort_imports.dart';

String mainAppDartTemplate(String appName, String localizationImport) =>
    '''
${sortImports(["import 'package:flutter/material.dart';", "import 'package:flutter_localizations/flutter_localizations.dart';", "import '$localizationImport';"])}

import 'di/di_container.dart';
import 'router/${appName}_router.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return TranslationProvider(child: const _AppView());
  }
}

class _AppView extends StatelessWidget {
  const _AppView();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      scaffoldMessengerKey: diContainer<GlobalKey<ScaffoldMessengerState>>(),
      locale: TranslationProvider.of(context).flutterLocale,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: AppLocaleUtils.supportedLocales,
      routerConfig: diContainer<${pascalCase(appName)}Router>().router,
    );
  }
}
''';
