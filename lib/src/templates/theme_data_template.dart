import '../functions/shared/pascal_case.dart';

/// `lib/src/<base>_theme_data.dart`: the root token container,
/// `<Base>ThemeData`.
String themeDataTemplate(String base) {
  final p = pascalCase(base);
  return '''
import 'package:flutter/foundation.dart';

import 'adaptive_color.dart';

/// Root token container. Add component groups from `theme_components/`
/// as fields here (and include them in == / hashCode).
@immutable
class ${p}ThemeData {
  const ${p}ThemeData({required this.brandColor});

  final AdaptiveColor brandColor;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ${p}ThemeData && other.brandColor == brandColor;

  @override
  int get hashCode => brandColor.hashCode;
}
''';
}
