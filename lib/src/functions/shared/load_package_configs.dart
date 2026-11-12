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
    for (final key in const ['utils', 'localization', 'router', 'network'])
      key:
          readCleanHelperFields(['packages', key])['create']?.toLowerCase() !=
          'false',
  };
  utilsPackageConfig = readPackageConfig('utils');
  networkPackageConfig = readPackageConfig('network');
  localizationPackageConfig = readPackageConfig('localization');
  routerPackageConfig = readPackageConfig('router');

  final network = readCleanHelperFields(['packages', 'network']);
  networkModuleNameConfig = network['module_name'];
  networkAuthInterceptorConfig =
      network['auth_interceptor']?.toLowerCase() != 'false';

  final utils = readCleanHelperFields(['packages', 'utils']);
  utilsModuleNameConfig = utils['module_name'];
  callAdapterNameConfig = utils['call_adapter_name'];

  slangSettingsConfig = Map.of(
    readCleanHelperFields(['packages', 'localization']),
  )..removeWhere((key, _) => const {'name', 'import', 'create'}.contains(key));

  final root = readCleanHelperFields([]);

  overwriteAnalysisOptionsConfig =
      (readCleanHelperFields(['packages'])['overwrite_analysis_options'] ??
              root['overwrite_analysis_options'])
          ?.toLowerCase() !=
      'false';
  useRootAnalysisConfig =
      (readCleanHelperFields(['packages'])['use_root_analysis'] ??
              root['use_root_analysis'])
          ?.toLowerCase() !=
      'false';
}
