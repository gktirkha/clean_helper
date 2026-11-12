/// `lib/src/di/<network>_module.dart`: [moduleName] registers `BaseOptions`
/// from the app's `NetworkConfig`, `RetrofitLogger` as `ParseErrorLogger`,
/// and `Dio` with Dio Lens. With [auth], `Dio` gets the app's
/// `AuthInterceptor` and a `@Named(NetworkDIKeys.noAuthDio)` Dio without it
/// is added. Error responses are turned into failures by the app's call
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
    if (auth) "import '../network_di_keys.dart';",
    "import '../utils/retrofit_logger.dart';",
  ].join('\n');

  final dio = auth
      ? '''
  @lazySingleton
  Dio dio(AuthInterceptor authInterceptor, BaseOptions baseOptions) {
    final dio = Dio(baseOptions);
    dio.interceptors.addAll([
      authInterceptor,
      DioLensInterceptor(dio: dio, name: 'api'),
    ]);
    return dio;
  }

  @lazySingleton
  @Named(NetworkDIKeys.noAuthDio)
  Dio noAuthDio(BaseOptions baseOptions) {
    final dio = Dio(baseOptions);
    dio.interceptors.add(DioLensInterceptor(dio: dio, name: 'no-auth'));
    return dio;
  }'''
      : '''
  @lazySingleton
  Dio dio(BaseOptions baseOptions) {
    final dio = Dio(baseOptions);
    dio.interceptors.add(DioLensInterceptor(dio: dio, name: 'api'));
    return dio;
  }''';

  return '''
$imports

/// Requires the host app to register a [NetworkConfig].
@module
abstract class $moduleName {
  @lazySingleton
  BaseOptions baseOptions(NetworkConfig config) => BaseOptions(
    baseUrl: config.baseUrl,
    connectTimeout: config.connectTimeout,
    receiveTimeout: config.receiveTimeout,
    sendTimeout: config.sendTimeout,
    headers: config.headers,
  );

  @LazySingleton(as: ParseErrorLogger)
  RetrofitLogger get retrofitLogger => RetrofitLogger();

$dio
}
''';
}
