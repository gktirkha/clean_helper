import '../functions/shared/camel_case.dart';
import '../functions/shared/pascal_case.dart';

/// `lib/src/<base>_material_theme.dart`: maps `<Base>ThemeData` to Material
/// `ThemeData`. [base] is the theme package name without `_theme`.
String themeMaterialThemeTemplate(String base) {
  final p = pascalCase(base);
  final c = camelCase(base);
  return '''
import 'package:material_ui/material_ui.dart';

import '${base}_theme_data.dart';

/// Maps [${p}ThemeData] to Material [ThemeData] for one [brightness].
/// Use it for both `theme` and `darkTheme` on `MaterialApp`.
ThemeData ${c}MaterialThemeData(
  ${p}ThemeData data, {
  required Brightness brightness,
}) {
  return ThemeData(
    brightness: brightness,
    colorScheme: ColorScheme.fromSeed(
      seedColor: data.brandColor.resolve(brightness),
      brightness: brightness,
    ),
    // Map more component tokens to Material sub-themes here.
  );
}
''';
}
