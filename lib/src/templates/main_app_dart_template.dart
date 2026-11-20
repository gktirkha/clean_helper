import '../functions/shared/camel_case.dart';
import '../functions/shared/pascal_case.dart';
import '../functions/shared/sort_imports.dart';

/// `lib/app/main_app.dart`: `MainApp` wraps the app in the theme package's
/// `<Base>Theme` (with `appTheme()`) and slang's `TranslationProvider`, and
/// builds `MaterialApp.router` with light / dark themes and the theme mode
/// from the theme scope. [themeBase] is the theme package name without
/// `_theme`.
String mainAppDartTemplate(
  String appName,
  String localizationImport,
  String themeImport,
  String themeBase,
) {
  final theme = pascalCase(themeBase);
  final materialTheme = '${camelCase(themeBase)}MaterialThemeData';
  return '''
${sortImports(["import 'package:material_ui/material_ui.dart';", "import '$localizationImport';", "import '$themeImport';"])}

import '../core/theme/app_theme.dart';
import 'di/di_container.dart';
import 'router/${appName}_router.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return TranslationProvider(
      child: ${theme}Theme(theme: appTheme(), child: const _AppView()),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView();

  @override
  Widget build(BuildContext context) {
    final scope = ${theme}Theme.scopeOf(context);
    return MaterialApp.router(
      theme: $materialTheme(
        scope.theme,
        brightness: Brightness.light,
      ),
      darkTheme: $materialTheme(
        scope.theme,
        brightness: Brightness.dark,
      ),
      themeMode: scope.themeMode,
      scaffoldMessengerKey: diContainer<GlobalKey<ScaffoldMessengerState>>(),
      locale: TranslationProvider.of(context).flutterLocale,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: AppLocaleUtils.supportedLocales,
      routerConfig: diContainer<${pascalCase(appName)}Router>().router,
    );
  }
}
''';
}
