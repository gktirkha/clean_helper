import 'package_configs.dart';

/// The theme package's class and file prefix: its name without a trailing
/// `_theme` (`workspace_theme` → `workspace`, giving `WorkspaceTheme`,
/// `WorkspaceThemeData`, `workspace_theme_data.dart`, …).
String themeBase(PackageConfig theme) => theme.name.endsWith('_theme')
    ? theme.name.substring(0, theme.name.length - '_theme'.length)
    : theme.name;
