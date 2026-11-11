import '../functions/shared/sort_imports.dart';

String mainAppDartTemplate(String localizationImport) =>
    '''
${sortImports(["import 'package:flutter/material.dart';", "import 'package:flutter_localizations/flutter_localizations.dart';", "import '$localizationImport';"])}

import 'di/di_container.dart';
import 'router/app_go_router.dart';

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
      routerConfig: diContainer<AppGoRouter>().router,
    );
  }
}
''';
