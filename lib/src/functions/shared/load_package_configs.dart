import 'package_configs.dart';
import 'read_clean_helper_fields.dart';
import 'read_package_config.dart';

/// Reads `clean-helper.packages`, `clean-helper.result_type` and
/// `clean-helper.retrofit_call_adapter` from the pubspec in the current
/// directory into the globals in `package_configs.dart`.
///
/// Must run before [resolveMonoRepoProject] changes into the app directory,
/// so that the monorepo root pubspec is the one read.
void loadPackageConfigs() {
  packageConfigsLoaded = true;
  utilsPackageConfig = readPackageConfig('utils');
  networkPackageConfig = readPackageConfig('network');
  localizationPackageConfig = readPackageConfig('localization');
  routerPackageConfig = readPackageConfig('router');

  final utils = readCleanHelperFields(['packages', 'utils']);
  utilsModuleNameConfig = utils['module_name'];
  callAdapterNameConfig = utils['call_adapter_name'];

  slangSettingsConfig = Map.of(
    readCleanHelperFields(['packages', 'localization']),
  )..removeWhere((key, _) => const {'name', 'import', 'create'}.contains(key));

  final root = readCleanHelperFields([]);

  var vscode = readCleanHelperFields(['packages', 'vs_code_configs']);
  if (vscode.isEmpty) vscode = readCleanHelperFields(['vs_code_configs']);
  bool enabled(String key) => vscode[key]?.toLowerCase() != 'false';
  vscodeConfig = (
    extensions: enabled('extensions'),
    tasks: enabled('tasks'),
    launch: enabled('launch'),
  );
  resultTypeConfig = root['result_type'];
  useRootAnalysisConfig =
      (readCleanHelperFields(['packages'])['use_root_analysis'] ??
              root['use_root_analysis'])
          ?.toLowerCase() ==
      'true';

  final adapter = readCleanHelperFields(['retrofit_call_adapter']);
  retrofitCallAdapterConfig = adapter.isEmpty
      ? null
      : (
          name: adapter['name'] ?? 'RetrofitCallAdapter',
          import: adapter['import'],
        );
}
