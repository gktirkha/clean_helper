import '../functions/shared/pascal_case.dart';

/// `lib/src/<base>_theme.dart`: `<Base>Theme`, placed above `MaterialApp`;
/// rebuilds dependents when brightness or theme mode changes.
String themeWidgetTemplate(String base) {
  final p = pascalCase(base);
  return '''
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'theme_manager/theme_resolver.dart';
import '${base}_theme_data.dart';
import '${base}_theme_scope.dart';

/// Place above `MaterialApp`. Rebuilds dependents when brightness or
/// theme mode changes.
class ${p}Theme extends StatefulWidget {
  const ${p}Theme({super.key, required this.theme, required this.child});

  final ${p}ThemeData theme;
  final Widget child;

  static ${p}ThemeData of(BuildContext context) => scopeOf(context).theme;

  static ${p}ThemeScope scopeOf(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<${p}ThemeScope>();
    assert(scope != null, 'No ${p}Theme found in context');
    return scope!;
  }

  @override
  State<${p}Theme> createState() => _${p}ThemeState();
}

class _${p}ThemeState extends State<${p}Theme> {
  @override
  void initState() {
    super.initState();
    ThemeResolver.instance.addListener(_onChange);
  }

  @override
  void dispose() {
    ThemeResolver.instance.removeListener(_onChange);
    super.dispose();
  }

  void _onChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final brightness = ThemeResolver.brightness;
    return ${p}ThemeScope(
      theme: widget.theme,
      brightness: brightness,
      themeMode: ThemeResolver.themeMode,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        child: widget.child,
      ),
    );
  }
}
''';
}
