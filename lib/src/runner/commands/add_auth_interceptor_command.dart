import 'package:args/command_runner.dart';

import '../../commands/add_auth_interceptor.dart';

class AddAuthInterceptorCommand extends Command<void> {
  @override
  String get name => 'add-auth-interceptor';

  @override
  String get description =>
      'Scaffold an AuthInterceptor with token refresh, wire it into NetworkModule, '
      'and add DIKeys.noAuthDio.';

  @override
  void run() => addAuthInterceptor();
}
