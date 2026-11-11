import 'package_configs.dart';
import 'read_package_name.dart';

/// `clean-helper.packages.network`, or the default `<app>_network` package.
/// Reads the app name from the current directory.
PackageConfig resolveNetworkPackage() {
  final configured = networkPackageConfig;
  if (configured != null) return configured;
  final name = '${readPackageName()}_network';
  return (name: name, import: 'package:$name/$name.dart', create: true);
}
