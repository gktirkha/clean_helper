/// `lib/src/theme_manager/theme_resolver.dart` in the theme package: the
/// effective brightness from the platform plus an in-app `ThemeMode`.
String themeResolverTemplate() => '''
import 'package:material_ui/material_ui.dart';

/// Tracks the effective [Brightness] from the platform plus an optional
/// in-app [ThemeMode] override.
class ThemeResolver extends ChangeNotifier with WidgetsBindingObserver {
  ThemeResolver._() {
    WidgetsBinding.instance.addObserver(this);
  }

  static final ThemeResolver instance = ThemeResolver._();

  ThemeMode _themeMode = ThemeMode.system;

  static ThemeMode get themeMode => instance._themeMode;

  static Brightness get brightness => switch (instance._themeMode) {
    ThemeMode.light => Brightness.light,
    ThemeMode.dark => Brightness.dark,
    ThemeMode.system =>
      WidgetsBinding.instance.platformDispatcher.platformBrightness,
  };

  static Brightness get inverseBrightness =>
      brightness == Brightness.dark ? Brightness.light : Brightness.dark;

  /// Force light / dark, or follow the system again with [ThemeMode.system].
  void setThemeMode(ThemeMode mode) {
    if (mode == _themeMode) return;
    _themeMode = mode;
    notifyListeners();
  }

  @override
  void didChangePlatformBrightness() {
    if (_themeMode == ThemeMode.system) notifyListeners();
  }
}
''';
