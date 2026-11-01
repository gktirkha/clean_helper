String contextUtilsTemplate() => '''
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'di/di_container.dart';

abstract final class ContextUtils {
  // ─────────────────────────────────────────────
  // Root Navigator
  // ─────────────────────────────────────────────

  static final GlobalKey<NavigatorState> _nav =
      diContainer<GlobalKey<NavigatorState>>();

  static GlobalKey<NavigatorState> get rootNavigatorKey => _nav;

  static NavigatorState? get rootNavigator => _nav.currentState;

  static BuildContext? get rootContext => rootNavigator?.context;

  static OverlayState? get rootOverlay => rootNavigator?.overlay;

  // Default global context refers to root navigator.
  static BuildContext? get currentContext => rootContext;

  static NavigatorState? get navigator => rootNavigator;

  static OverlayState? get overlay => rootOverlay;

  static bool get hasContext => currentContext != null;

  static bool get canPop => rootNavigator?.canPop() ?? false;

  // ─────────────────────────────────────────────
  // Theme
  // ─────────────────────────────────────────────

  static ThemeData? get theme {
    final context = currentContext;
    return context == null ? null : Theme.of(context);
  }

  static ColorScheme? get colorScheme => theme?.colorScheme;

  static TextTheme? get textTheme => theme?.textTheme;

  static Brightness get brightness => theme?.brightness ?? Brightness.light;

  static bool get isDarkMode => brightness == Brightness.dark;

  static bool get isLightMode => !isDarkMode;

  // ─────────────────────────────────────────────
  // Media Query & Screen
  // ─────────────────────────────────────────────

  static MediaQueryData? get mediaQuery {
    final context = currentContext;
    return context == null ? null : MediaQuery.maybeOf(context);
  }

  static Size get screenSize => mediaQuery?.size ?? Size.zero;

  static double get screenWidth => screenSize.width;

  static double get screenHeight => screenSize.height;

  static double get statusBarHeight => mediaQuery?.padding.top ?? 0;

  static double get bottomSafeArea => mediaQuery?.padding.bottom ?? 0;

  static double get leftSafeArea => mediaQuery?.padding.left ?? 0;

  static double get rightSafeArea => mediaQuery?.padding.right ?? 0;

  static EdgeInsets get viewPadding =>
      mediaQuery?.viewPadding ?? EdgeInsets.zero;

  static EdgeInsets get viewInsets => mediaQuery?.viewInsets ?? EdgeInsets.zero;

  static double get keyboardHeight => mediaQuery?.viewInsets.bottom ?? 0;

  static bool get isKeyboardVisible => keyboardHeight > 0;

  static double get devicePixelRatio => mediaQuery?.devicePixelRatio ?? 1.0;

  static Orientation get orientation =>
      mediaQuery?.orientation ?? Orientation.portrait;

  static bool get isPortrait => orientation == Orientation.portrait;

  static bool get isLandscape => orientation == Orientation.landscape;

  // Responsive
  static bool get isMobile => screenWidth < 600;

  static bool get isTablet => screenWidth >= 600 && screenWidth < 1024;

  static bool get isDesktop => screenWidth >= 1024;

  static double get availableHeight => screenHeight - keyboardHeight;

  // ─────────────────────────────────────────────
  // Focus & Keyboard
  // ─────────────────────────────────────────────

  static FocusNode? get primaryFocus => FocusManager.instance.primaryFocus;

  static bool get hasFocus => primaryFocus != null;

  static void unfocus() {
    primaryFocus?.unfocus();
  }

  static void hideKeyboard() {
    unfocus();
  }

  // ─────────────────────────────────────────────
  // Snackbar
  // ─────────────────────────────────────────────

  static void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
    SnackBarAction? action,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    BuildContext? context,
  }) {
    final targetContext = context ?? rootContext;
    if (targetContext == null) return;

    final messenger = ScaffoldMessenger.maybeOf(targetContext);
    if (messenger == null) return;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: duration,
          backgroundColor: backgroundColor,
          action: action,
          behavior: behavior,
        ),
      );
  }

  static void hideSnackBar({BuildContext? context}) {
    final targetContext = context ?? rootContext;
    if (targetContext == null) return;

    ScaffoldMessenger.maybeOf(targetContext)?.hideCurrentSnackBar();
  }

  static void clearSnackBars({BuildContext? context}) {
    final targetContext = context ?? rootContext;
    if (targetContext == null) return;

    ScaffoldMessenger.maybeOf(targetContext)?.clearSnackBars();
  }

  // ─────────────────────────────────────────────
  // Dialog
  // ─────────────────────────────────────────────

  static Future<T?> showAppDialog<T>({
    required WidgetBuilder builder,
    BuildContext? context,
    bool barrierDismissible = true,
    bool useRootNavigator = true,
    Color? barrierColor,
    bool useSafeArea = true,
  }) {
    final targetContext = context ?? rootContext;

    if (targetContext == null) {
      return Future<T?>.value();
    }

    return showDialog<T>(
      context: targetContext,
      builder: builder,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      barrierColor: barrierColor,
      useSafeArea: useSafeArea,
    );
  }

  // ─────────────────────────────────────────────
  // Bottom Sheet
  // ─────────────────────────────────────────────

  static Future<T?> showAppBottomSheet<T>({
    required WidgetBuilder builder,
    BuildContext? context,
    bool isScrollControlled = true,
    bool isDismissible = true,
    bool enableDrag = true,
    bool useRootNavigator = false,
    Color? backgroundColor,
    ShapeBorder? shape,
    bool useSafeArea = false,
    double? elevation,
  }) {
    final targetContext = context ?? rootContext;

    if (targetContext == null) {
      return Future<T?>.value();
    }

    return showModalBottomSheet<T>(
      context: targetContext,
      builder: builder,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      useRootNavigator: useRootNavigator,
      backgroundColor: backgroundColor,
      shape: shape,
      useSafeArea: useSafeArea,
      elevation: elevation,
    );
  }

  // ─────────────────────────────────────────────
  // Clipboard
  // ─────────────────────────────────────────────

  static Future<void> copyToClipboard(String value) {
    return Clipboard.setData(ClipboardData(text: value));
  }

  // ─────────────────────────────────────────────
  // Haptic Feedback
  // ─────────────────────────────────────────────

  static Future<void> lightHaptic() => HapticFeedback.lightImpact();

  static Future<void> mediumHaptic() => HapticFeedback.mediumImpact();

  static Future<void> heavyHaptic() => HapticFeedback.heavyImpact();

  static Future<void> selectionHaptic() => HapticFeedback.selectionClick();

  static Future<void> vibrate() => HapticFeedback.vibrate();

  // ─────────────────────────────────────────────
  // System UI
  // ─────────────────────────────────────────────

  static void setSystemUIOverlayStyle(SystemUiOverlayStyle style) {
    SystemChrome.setSystemUIOverlayStyle(style);
  }

  static Future<void> hideSystemUI() {
    return SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  static Future<void> showSystemUI() {
    return SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  static Future<void> setPreferredOrientations(
    List<DeviceOrientation> orientations,
  ) {
    return SystemChrome.setPreferredOrientations(orientations);
  }

  static Future<void> resetPreferredOrientations() {
    return setPreferredOrientations(DeviceOrientation.values);
  }
}
''';
