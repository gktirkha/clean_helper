import '../functions/shared/sort_imports.dart';

/// [loggerImport] is where `RetrofitLogger` comes from: `../utils/retrofit_logger.dart`,
/// or the utils package for projects initialised before 1.4.4.
///
/// [registerErrorLogger] is false when the utils package already registers
/// `ParseErrorLogger` (projects initialised before 1.4.1), since a second
/// registration makes GetIt throw.
String networkModuleTemplate(
  String loggerImport, {
  bool registerErrorLogger = true,
}) {
  final packageLogger = loggerImport.startsWith('package:');

  final errorLogger = registerErrorLogger
      ? '\n\n  @LazySingleton(as: ParseErrorLogger)\n'
            '  RetrofitLogger get retrofitLogger => RetrofitLogger();'
      : '';

  return '''
import 'dart:io';

${sortImports(["import 'package:dio/dio.dart';", "import 'package:dio_lens/dio_lens.dart';", "import 'package:injectable/injectable.dart';", "import 'package:package_info_plus/package_info_plus.dart';", if (registerErrorLogger) "import 'package:retrofit/retrofit.dart';", if (registerErrorLogger && packageLogger) "import '$loggerImport';"])}

${sortImports(["import '../constants/api_paths.dart';", "import '../interceptors/error_interceptor.dart';", if (registerErrorLogger && !packageLogger) "import '$loggerImport';"])}

@module
abstract class NetworkModule {
  @lazySingleton
  BaseOptions baseOptions(PackageInfo packageInfo) => BaseOptions(
    baseUrl: ApiPaths.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(minutes: 5),
    headers: {
      'User-Agent':
          '\${packageInfo.appName}-\${Platform.operatingSystem}/\${packageInfo.version}+\${packageInfo.buildNumber}',
    },
  );$errorLogger

  @lazySingleton
  Dio dio(
    BaseOptions baseOptions,
    ErrorInterceptor errorInterceptor,
  ) {
    final dio = Dio(baseOptions);
    dio.interceptors.addAll([
      errorInterceptor,
      DioLensInterceptor(dio: dio, name: 'api'),
    ]);
    return dio;
  }
}
''';
}
