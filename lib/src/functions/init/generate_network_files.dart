import 'dart:io';

import '../shared/write_file.dart';

void generateNetworkFiles() {
  writeFile('lib/core/network/constants/api_paths.dart', '''
sealed class ApiPaths {
  static const String baseUrl = 'https://your-api.com/api/';
}
''');

  writeFile('lib/core/domain/entities/error_entity.dart', '''
abstract class ErrorEntity {
  List<String> get errors;
}
''');

  writeFile('lib/core/data/models/error_model.dart', '''
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/error_entity.dart';

part 'error_model.freezed.dart';
part 'error_model.g.dart';

@freezed
sealed class ErrorModel with _\$ErrorModel implements ErrorEntity {
  const factory ErrorModel({
    @Default([]) @JsonKey(name: 'errors') List<String> errors,
  }) = _ErrorModel;

  factory ErrorModel.fromJson(Map<String, dynamic> json) =>
      _\$ErrorModelFromJson(json);
}
''');

  writeFile('lib/core/network/interceptors/error_interceptor.dart', '''
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/error_model.dart';

@lazySingleton
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final response = err.response;
    final statusCode = response?.statusCode;

    if (statusCode == null || statusCode == 401 || response == null) {
      handler.next(err);
      return;
    }

    final data = response.data;

    final isValidErrorResponse =
        data is Map<String, dynamic> &&
        data.containsKey('errors') &&
        data['errors'] is List;

    if (!isValidErrorResponse) {
      handler.next(err);
      return;
    }

    final errorList = ErrorModel.fromJson(data);

    if (errorList.errors.isEmpty) {
      handler.next(err);
      return;
    }

    handler.next(
      err.copyWith(
        response: Response(
          requestOptions: response.requestOptions,
          data: errorList,
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
          headers: response.headers,
          extra: response.extra,
          isRedirect: response.isRedirect,
          redirects: response.redirects,
        ),
      ),
    );
  }
}
''');

  writeFile('lib/core/network/di/network_module.dart', '''
import 'dart:io';

import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../constants/api_paths.dart';
import '../interceptors/error_interceptor.dart';

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
  Dio dio(
    BaseOptions baseOptions,
    ErrorInterceptor errorInterceptor,
  ) => Dio(baseOptions)
    ..interceptors.addAll([
      errorInterceptor,
      ChuckerDioInterceptor(),
      PrettyDioLogger(),
    ]);
}
''');

  stdout.writeln('🌐 Network module generated');
}
