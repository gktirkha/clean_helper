/// `lib/core/di/test_environment_core_module.dart`: `@test` stand-ins for
/// `CoreModule`'s `@dev` / `@prod` registrations (a fixed `PackageInfo` for
/// [appName]), used when DI runs with `environment: Environment.test`.
String testEnvironmentCoreModuleTemplate(String appName) =>
    '''
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// `@test` counterparts of the `@dev` / `@prod` registrations in `CoreModule`,
/// used when DI is initialised with `environment: Environment.test`.
///
/// Tag each member with `@test`: a tag on the module class is not applied to
/// its members.
@module
abstract class TestEnvironmentCoreModule {
  @test
  @lazySingleton
  PackageInfo get packageInfo => PackageInfo(
    appName: '${appName}_test',
    packageName: 'com.example.$appName.test',
    version: '0.0.0',
    buildNumber: '0',
  );
}
''';
