import '../functions/shared/pascal_case.dart';
import '../functions/shared/sort_imports.dart';

/// `lib/core/theme/app_theme.dart`: the app's design tokens for the theme
/// package ([themeImport]); [base] is its name without `_theme`.
String appThemeTemplate(String themeImport, String base) =>
    '''
${sortImports(["import '$themeImport';", "import 'package:material_ui/material_ui.dart';"])}

${pascalCase(base)}ThemeData appTheme() =>
    ${pascalCase(base)}ThemeData(brandColor: .all(Colors.blue));
''';
