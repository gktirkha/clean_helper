import 'package:args/command_runner.dart';

import '../../commands/init.dart';

/// `init` generates the network package and the home DI module unless
/// skipped; `tools/` only with `--tools`.
class InitCommand extends Command<void> {
  InitCommand() {
    argParser.addFlag(
      'skip-network',
      abbr: 'n',
      negatable: false,
      help:
          "Don't create the network package or wire the app to it "
          '(see clean-helper.packages.network).',
    );
    argParser.addFlag(
      'skip-di',
      abbr: 'd',
      negatable: false,
      help: "Don't generate a DI module for the home feature.",
    );
    argParser.addFlag(
      'tools',
      abbr: 't',
      negatable: false,
      help: 'Also generate the tools/ scripts (not in a monorepo app).',
    );
  }

  @override
  String get name => 'init';

  @override
  String get description =>
      'Scaffold a Flutter clean architecture project in the current directory '
      '(network package and home DI module included unless skipped).';

  @override
  Future<void> run() => runInit(
    withNetwork: !(argResults!['skip-network'] as bool),
    withDi: !(argResults!['skip-di'] as bool),
    withTools: argResults!['tools'] as bool,
  );
}
