/// `lib/src/adaptive_color.dart` in the theme package: a `Color` that
/// resolves to its light or dark value at read time.
String themeAdaptiveColorTemplate() => '''
import 'dart:ui' show Brightness, Color, ColorSpace;

import 'theme_manager/theme_resolver.dart';

/// A [Color] that resolves to [light] or [dark] at read time, based on
/// [ThemeResolver.brightness]. Usable anywhere a [Color] is expected.
class AdaptiveColor extends Color {
  AdaptiveColor({required this.light, required this.dark}) : super(0);

  /// Same color in both modes.
  AdaptiveColor.all(Color color) : this(light: color, dark: color);

  final Color light;
  final Color dark;

  Color resolve(Brightness brightness) =>
      brightness == Brightness.dark ? dark : light;

  Color get currentColor => resolve(ThemeResolver.brightness);
  Color get inverse => resolve(ThemeResolver.inverseBrightness);

  @override
  double get a => currentColor.a;
  @override
  double get r => currentColor.r;
  @override
  double get g => currentColor.g;
  @override
  double get b => currentColor.b;
  @override
  ColorSpace get colorSpace => currentColor.colorSpace;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdaptiveColor && other.light == light && other.dark == dark;

  @override
  int get hashCode => Object.hash(light, dark);

  @override
  String toString() => 'AdaptiveColor(light: \$light, dark: \$dark)';
}
''';
