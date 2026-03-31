String noAuthDioMethodTemplate() => '''

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
    ]);''';
