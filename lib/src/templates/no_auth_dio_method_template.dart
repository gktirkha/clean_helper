/// The `@Named(DIKeys.noAuthDio)` Dio that `add-auth-interceptor` appends to
/// `NetworkModule`: no `AuthInterceptor`, so token refreshes can't loop.
String noAuthDioMethodTemplate() => '''

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
