import 'dart:io';

import '../../templates/auth_interceptor_template.dart';
import '../../templates/error_interceptor_template.dart';
import '../../templates/micro_package_di_initializer_template.dart';
import '../../templates/network_config_template.dart';
import '../../templates/network_di_keys_template.dart';
import '../../templates/network_lib_export_template.dart';
import '../../templates/network_package_module_template.dart';
import '../../templates/network_pubspec_tail_template.dart';
import '../../templates/retrofit_logger_template.dart';
import '../shared/package_barrel_path.dart';
import '../shared/package_barrel_prefix.dart';
import '../shared/package_configs.dart';
import '../shared/write_file.dart';
import 'patch_package_pubspec.dart';
import 'scaffold_package.dart';

/// Creates the network package in `<parentDir>/<name>`: an injectable
/// micro-package with the freezed `NetworkConfig`, the Dio module
/// ([moduleName]), the abstract `ErrorInterceptor` and `RetrofitLogger`, plus
/// the abstract `AuthInterceptor`, `noAuthDio` and `NetworkDIKeys` when [auth]
/// is true. [utils] provides `ErrorEntity` and `AppLogger`.
void generateNetworkPackage(
  PackageConfig package,
  PackageConfig utils, {
  required String moduleName,
  required bool auth,
  String parentDir = 'packages',
}) {
  final dir = '$parentDir/${package.name}';
  stdout.writeln('📦 Creating ${package.name} package...');

  scaffoldPackage(package, parentDir: parentDir);
  patchPackagePubspec(dir, networkPubspecTailTemplate(utils.name));

  overwriteFile(
    packageBarrelPath(package, parentDir),
    networkLibExportTemplate(packageBarrelPrefix(package), auth: auth),
  );
  overwriteFile(
    '$dir/lib/src/di/di_initializer.dart',
    microPackageDiInitializerTemplate(),
  );
  overwriteFile(
    '$dir/lib/src/di/${package.name}_module.dart',
    networkPackageModuleTemplate(moduleName, auth: auth),
  );
  overwriteFile(
    '$dir/lib/src/interceptors/error_interceptor.dart',
    errorInterceptorTemplate(utils.import),
  );
  overwriteFile(
    '$dir/lib/src/models/network_config.dart',
    networkConfigTemplate(),
  );
  overwriteFile(
    '$dir/lib/src/utils/retrofit_logger.dart',
    retrofitLoggerTemplate(utils.import),
  );
  if (auth) {
    overwriteFile(
      '$dir/lib/src/interceptors/auth_interceptor.dart',
      authInterceptorTemplate(),
    );
    overwriteFile('$dir/lib/src/network_di_keys.dart', networkDiKeysTemplate());
  }

  stdout.writeln('📦 ${package.name} package created');
  stdout.writeln();
}
