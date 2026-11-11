/// `lib/core/network/interceptors/app_auth_interceptor.dart`: the app's token
/// logic for the network package's abstract `AuthInterceptor`.
String appAuthInterceptorTemplate(String networkImport) =>
    '''
import '$networkImport';

class AppAuthInterceptor extends AuthInterceptor {
  AppAuthInterceptor({required super.noAuthDio});

  @override
  Future<String?> getAccessToken() async {
    // TODO: Read access token from storage
    // Example: return _tokenStorage.getAccessToken();
    return null;
  }

  @override
  Future<String?> refreshAccessToken() async {
    // TODO: Handle full token refresh flow
    // - Read refresh token from storage
    // - Call refresh API using noAuthDio
    // - Persist new access + refresh tokens
    // - Return new access token
    return null;
  }

  @override
  Future<void> onRefreshFailed(Object? error, StackTrace? stackTrace) async {
    // TODO: Clear stored tokens & handle logout
  }
}
''';
