import 'package_configs.dart';
import 'read_package_name.dart';

/// `clean-helper.foundation.theme`, or the default `<app>_theme` package
/// (created by `init`). Reads the app name from the current directory.
PackageConfig resolveThemePackage() {
  final configured = themePackageConfig;
  if (configured != null) return configured;
  final name = '${readPackageName()}_theme';
  return (
    name: name,
    import: 'package:$name/$name.dart',
    create: packageCreateConfig['theme'] ?? true,
  );
}
