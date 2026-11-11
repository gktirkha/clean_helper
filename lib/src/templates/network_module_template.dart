String networkModuleTemplate() => '''
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_lens/dio_lens.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:retrofit/retrofit.dart';

import '../constants/api_paths.dart';
import '../interceptors/error_interceptor.dart';
import '../utils/retrofit_logger.dart';

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

  @LazySingleton(as: ParseErrorLogger)
  RetrofitLogger get retrofitLogger => RetrofitLogger();

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
