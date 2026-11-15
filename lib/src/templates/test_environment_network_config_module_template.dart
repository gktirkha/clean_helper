import '../functions/shared/sort_imports.dart';

/// `lib/core/network/di/test_environment_network_config_module.dart`: `@test`
/// stand-in for `NetworkConfigModule`'s `NetworkConfig`, used when DI runs
/// with `environment: Environment.test`.
String testEnvironmentNetworkConfigModuleTemplate(String networkImport) =>
    '''
${sortImports(["import '$networkImport';", "import 'package:injectable/injectable.dart';"])}

/// `@test` counterparts of the `@dev` / `@prod` registrations in
/// `NetworkConfigModule`, used when DI is initialised with
/// `environment: Environment.test`.
///
/// Tag each member with `@test`: a tag on the module class is not applied to
/// its members.
@module
abstract class TestEnvironmentNetworkConfigModule {
  @test
  @lazySingleton
  NetworkConfig get networkConfig =>
      const NetworkConfig(baseUrl: 'http://localhost/');
}
''';
