import 'package_configs.dart';
import 'read_clean_helper_fields.dart';
import 'read_package_config.dart';

/// Reads the `clean-helper` keys from the pubspec in the current
/// directory into the globals in `package_configs.dart`.
///
/// Must run before [resolveMonoRepoProject] changes into the app directory,
/// so that the monorepo root pubspec is the one read.
void loadPackageConfigs() {
  packageConfigsLoaded = true;
  packageCreateConfig = {
    for (final key in const [
      'utils',
      'localization',
      'router',
      'theme',
      'network',
    ])
      key:
          readCleanHelperFields(['foundation', key])['create']?.toLowerCase() !=
          'false',
  };
  packagesDirConfig = readCleanHelperFields(['foundation'])['dir'];
  utilsPackageConfig = readPackageConfig('utils');
  networkPackageConfig = readPackageConfig('network');
  localizationPackageConfig = readPackageConfig('localization');
  routerPackageConfig = readPackageConfig('router');
  themePackageConfig = readPackageConfig('theme');

  final network = readCleanHelperFields(['foundation', 'network']);
  networkModuleNameConfig = network['module_name'];
  callAdapterNameConfig = network['call_adapter_name'];
  networkAuthInterceptorConfig =
      network['auth_interceptor']?.toLowerCase() != 'false';

  final utils = readCleanHelperFields(['foundation', 'utils']);
  utilsModuleNameConfig = utils['module_name'];

  slangSettingsConfig = Map.of(
    readCleanHelperFields(['foundation', 'localization']),
  )..removeWhere((key, _) => const {'name', 'import', 'create'}.contains(key));

  final root = readCleanHelperFields([]);
  rootToolVersionConfig = root['version'];

  overwriteAnalysisOptionsConfig =
      (readCleanHelperFields(['foundation'])['overwrite_analysis_options'] ??
              root['overwrite_analysis_options'])
          ?.toLowerCase() !=
      'false';
  useRootAnalysisConfig =
      (readCleanHelperFields(['foundation'])['use_root_analysis'] ??
              root['use_root_analysis'])
          ?.toLowerCase() !=
      'false';
}
