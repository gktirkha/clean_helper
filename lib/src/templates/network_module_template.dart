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

${sortImports(["import 'package:chucker_flutter/chucker_flutter.dart';", "import 'package:dio/dio.dart';", "import 'package:injectable/injectable.dart';", "import 'package:package_info_plus/package_info_plus.dart';", "import 'package:pretty_dio_logger/pretty_dio_logger.dart';", if (registerErrorLogger) "import 'package:retrofit/retrofit.dart';", if (registerErrorLogger && packageLogger) "import '$loggerImport';"])}

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
  );

  @lazySingleton
  ChuckerDioInterceptor get chuckerDioInterceptor => ChuckerDioInterceptor();

  @lazySingleton
  PrettyDioLogger get prettyDioLogger => PrettyDioLogger();$errorLogger

  @lazySingleton
  Dio dio(
    BaseOptions baseOptions,
    ErrorInterceptor errorInterceptor,
    ChuckerDioInterceptor chuckerDioInterceptor,
    PrettyDioLogger prettyDioLogger,
  ) => Dio(baseOptions)
    ..interceptors.addAll([
      errorInterceptor,
      chuckerDioInterceptor,
      prettyDioLogger,
    ]);
}
''';
}
