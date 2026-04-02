import 'package:args/command_runner.dart';

import '../../commands/init.dart';

class InitCommand extends Command<void> {
  InitCommand() {
    argParser.addFlag(
      'network',
      abbr: 'n',
      negatable: false,
      help: 'Also set up the network layer (Dio, Retrofit, Chucker).',
    );
    argParser.addFlag(
      'di',
      abbr: 'd',
      negatable: false,
      help:
          'Also generate a di/home_di.dart injectable di for the home feature.',
    );
    argParser.addFlag(
      'auth-interceptor',
      abbr: 'a',
      negatable: false,
      help: 'Also scaffold the auth interceptor (implies --network).',
    );
  }

  @override
  String get name => 'init';

  @override
  String get description =>
      'Scaffold a Flutter clean architecture project in the current directory.';

  @override
  void run() => runInit(
    withNetwork: argResults!['network'] as bool,
    withDi: argResults!['di'] as bool,
    withAuthInterceptor: argResults!['auth-interceptor'] as bool,
  );
}
