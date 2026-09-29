import 'package_configs.dart';
import 'read_package_config.dart';

/// Reads `clean-helper.packages` from the pubspec in the current directory
/// into [utilsPackageConfig] and [networkPackageConfig].
///
/// Must run before [resolveMonoRepoProject] changes into the app directory,
/// so that the monorepo root pubspec is the one read.
void loadPackageConfigs() {
  utilsPackageConfig = readPackageConfig('utils');
  networkPackageConfig = readPackageConfig('network');
}
