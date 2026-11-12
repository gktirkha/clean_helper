import '../functions/shared/sort_imports.dart';

/// `lib/core/network/di/network_config_module.dart`: registers the
/// `NetworkConfig` the network package needs and, with [auth], the app's
/// `AuthInterceptor`.
String networkConfigModuleTemplate(String networkImport, {required bool auth}) {
  final authInterceptor = auth
      ? '''


  @lazySingleton
  AuthInterceptor authInterceptor(
    @Named(NetworkDIKeys.noAuthDio) Dio noAuthDio,
  ) => AppAuthInterceptor(noAuthDio: noAuthDio);'''
      : '';

  return '''
import 'dart:io';

${sortImports([if (auth) "import 'package:dio/dio.dart';", "import '$networkImport';", "import 'package:injectable/injectable.dart';", "import 'package:package_info_plus/package_info_plus.dart';"])}

${sortImports(["import '../constants/api_paths.dart';", if (auth) "import '../interceptors/app_auth_interceptor.dart';"])}

@module
abstract class NetworkConfigModule {
  @lazySingleton
  NetworkConfig networkConfig(PackageInfo packageInfo) => NetworkConfig(
    baseUrl: ApiPaths.baseUrl,
    headers: {
      'User-Agent':
          '\${packageInfo.appName}-\${Platform.operatingSystem}/\${packageInfo.version}+\${packageInfo.buildNumber}',
    },
  );$authInterceptor
}
''';
}
