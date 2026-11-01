/// [chucker] is true for network modules generated before 1.5.0, which still
/// register `ChuckerDioInterceptor` and `PrettyDioLogger` instead of using
/// Dio Lens.
String noAuthDioMethodTemplate({bool chucker = false}) => chucker
    ? '''

  @lazySingleton
  @Named(DIKeys.noAuthDio)
  Dio noAuthDio(
    BaseOptions baseOptions,
    PrettyDioLogger prettyDioLogger,
    ChuckerDioInterceptor chuckerDioInterceptor,
    ErrorInterceptor errorInterceptor,
  ) => Dio(baseOptions)
    ..interceptors.addAll([
      prettyDioLogger,
      chuckerDioInterceptor,
      errorInterceptor,
    ]);'''
    : '''

  @lazySingleton
  @Named(DIKeys.noAuthDio)
  Dio noAuthDio(BaseOptions baseOptions, ErrorInterceptor errorInterceptor) {
    final dio = Dio(baseOptions);
    dio.interceptors.addAll([
      DioLensInterceptor(dio: dio, name: 'no-auth'),
      errorInterceptor,
    ]);
    return dio;
  }''';
