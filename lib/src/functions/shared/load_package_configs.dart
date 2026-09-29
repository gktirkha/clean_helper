import 'package_configs.dart';
import 'read_clean_helper_fields.dart';
import 'read_package_config.dart';

/// Reads `clean-helper.packages`, `clean-helper.result_type` and
/// `clean-helper.retrofit_call_adapter` from the pubspec in the current
/// directory into [utilsPackageConfig], [networkPackageConfig],
/// [resultTypeConfig] and [retrofitCallAdapterConfig].
///
/// Must run before [resolveMonoRepoProject] changes into the app directory,
/// so that the monorepo root pubspec is the one read.
void loadPackageConfigs() {
  utilsPackageConfig = readPackageConfig('utils');
  networkPackageConfig = readPackageConfig('network');

  resultTypeConfig = readCleanHelperFields([])['result_type'];

  final adapter = readCleanHelperFields(['retrofit_call_adapter']);
  retrofitCallAdapterConfig = adapter.isEmpty
      ? null
      : (
          name: adapter['name'] ?? 'RetrofitCallAdapter',
          import: adapter['import'],
        );
}
