import 'package_configs.dart';
import 'read_package_name.dart';

/// `clean-helper.packages.localization`, or the default `<app>_localization`
/// package (created by `init`). Reads the app name from the current directory.
PackageConfig resolveLocalizationPackage() {
  final configured = localizationPackageConfig;
  if (configured != null) return configured;
  final name = '${readPackageName()}_localization';
  return (name: name, import: 'package:$name/$name.dart', create: true);
}
