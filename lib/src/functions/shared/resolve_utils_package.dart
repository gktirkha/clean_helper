import 'package_configs.dart';
import 'read_package_name.dart';

/// `clean-helper.packages.utils`, or the default `<app>_utils` package
/// (created by `init`). Reads the app name from the current directory.
PackageConfig resolveUtilsPackage() {
  final configured = utilsPackageConfig;
  if (configured != null) return configured;
  final name = '${readPackageName()}_utils';
  return (
    name: name,
    import: 'package:$name/$name.dart',
    create: packageCreateConfig['utils'] ?? true,
  );
}
