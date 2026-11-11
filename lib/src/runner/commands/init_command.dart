import 'package:args/command_runner.dart';

import '../../commands/init.dart';

class InitCommand extends Command<void> {
  InitCommand() {
    argParser.addFlag(
      'network',
      abbr: 'n',
      negatable: false,
      help:
          'Also create the network package and wire the app to it '
          '(see clean-helper.packages.network).',
    );
    argParser.addFlag(
      'di',
      abbr: 'd',
      negatable: false,
      help:
          'Also generate a di/home_di.dart injectable di for the home feature.',
    );
    argParser.addFlag(
      'tools',
      abbr: 't',
      negatable: false,
      help: 'Also generate the tools/ scripts.',
    );
  }

  @override
  String get name => 'init';

  @override
  String get description =>
      'Scaffold a Flutter clean architecture project in the current directory.';

  @override
  Future<void> run() => runInit(
    withNetwork: argResults!['network'] as bool,
    withDi: argResults!['di'] as bool,
    withTools: argResults!['tools'] as bool,
  );
}
