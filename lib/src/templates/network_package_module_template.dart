/// `lib/src/di/<network>_module.dart`: [moduleName] registers
/// `@Named(NetworkDIKeys.baseOptions)` `BaseOptions` from the app's
/// `NetworkConfig`, `RetrofitLogger` as `ParseErrorLogger`,
/// and `Dio` with Dio Lens. With [auth], `Dio` gets the app's
/// `AuthInterceptor` and a `@Named(NetworkDIKeys.noAuthDio)` Dio without it
/// is added. A `@Named(NetworkDIKeys.noBaseOptionsDio)` Dio without
/// `BaseOptions` is always added. Error responses are turned into failures by the app's call
/// adapter, not by an interceptor.
String networkPackageModuleTemplate(String moduleName, {required bool auth}) {
  final imports = [
    "import 'package:dio/dio.dart';",
    "import 'package:dio_lens/dio_lens.dart';",
    "import 'package:injectable/injectable.dart';",
    "import 'package:retrofit/retrofit.dart';",
    '',
    if (auth) "import '../interceptors/auth_interceptor.dart';",
    "import '../models/network_config.dart';",
    "import '../network_di_keys.dart';",
    "import '../utils/retrofit_logger.dart';",
  ].join('\n');

  final dio = auth
      ? '''
  @lazySingleton
  Dio dio(
    AuthInterceptor authInterceptor,
    @Named(NetworkDIKeys.baseOptions) BaseOptions baseOptions,
  ) {
    final dio = Dio(baseOptions);
    dio.interceptors.addAll([
      authInterceptor,
      DioLensInterceptor(dio: dio, name: 'api'),
    ]);
    return dio;
  }

  @lazySingleton
  @Named(NetworkDIKeys.noAuthDio)
  Dio noAuthDio(@Named(NetworkDIKeys.baseOptions) BaseOptions baseOptions) {
    final dio = Dio(baseOptions);
    dio.interceptors.add(
      DioLensInterceptor(dio: dio, name: NetworkDIKeys.noAuthDio),
    );
    return dio;
  }'''
      : '''
  @lazySingleton
  Dio dio(@Named(NetworkDIKeys.baseOptions) BaseOptions baseOptions) {
    final dio = Dio(baseOptions);
    dio.interceptors.add(DioLensInterceptor(dio: dio, name: 'api'));
    return dio;
  }''';

  // Every package gets a Dio without BaseOptions, e.g. for absolute URLs on
  // other hosts.
  const noBaseOptionsDio = '''

  @lazySingleton
  @Named(NetworkDIKeys.noBaseOptionsDio)
  Dio noBaseOptionsDio() {
    final dio = Dio();
    dio.interceptors.add(
      DioLensInterceptor(dio: dio, name: NetworkDIKeys.noBaseOptionsDio),
    );
    return dio;
  }''';

  return '''
$imports

/// Requires the host app to register a [NetworkConfig].
@module
abstract class $moduleName {
  @lazySingleton
  @Named(NetworkDIKeys.baseOptions)
  BaseOptions baseOptions(NetworkConfig config) => BaseOptions(
    baseUrl: config.baseUrl,
    connectTimeout: config.connectTimeout,
    receiveTimeout: config.receiveTimeout,
    sendTimeout: config.sendTimeout,
    headers: config.headers,
  );

  @LazySingleton(as: ParseErrorLogger)
  RetrofitLogger get retrofitLogger => RetrofitLogger();

$dio$noBaseOptionsDio
}
''';
}
