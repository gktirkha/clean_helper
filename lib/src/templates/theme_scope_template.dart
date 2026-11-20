import '../functions/shared/pascal_case.dart';

/// `lib/src/<base>_theme_scope.dart`: the `InheritedWidget` holding the
/// theme, brightness and theme mode.
String themeScopeTemplate(String base) {
  final p = pascalCase(base);
  return '''
import 'package:material_ui/material_ui.dart' show ThemeMode;
import 'package:flutter/widgets.dart';

import '${base}_theme_data.dart';

class ${p}ThemeScope extends InheritedWidget {
  const ${p}ThemeScope({
    super.key,
    required this.theme,
    required this.brightness,
    required this.themeMode,
    required super.child,
  });

  final ${p}ThemeData theme;
  final Brightness brightness;
  final ThemeMode themeMode;

  @override
  bool updateShouldNotify(${p}ThemeScope oldWidget) =>
      theme != oldWidget.theme ||
      brightness != oldWidget.brightness ||
      themeMode != oldWidget.themeMode;
}
''';
}
