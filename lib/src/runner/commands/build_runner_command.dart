import 'package:args/command_runner.dart';

import '../../commands/build_runner.dart';

class BuildRunnerCommand extends Command<void> {
  @override
  String get name => 'build_runner';

  @override
  String get description =>
      'Run build_runner in the current Flutter project.\n'
      'Usage: clean-helper build_runner [clean|build|watch]  (default: build)';

  @override
  String get invocation =>
      '${runner?.executableName} $name [clean|build|watch]';

  @override
  void run() => runBuildRunnerCommand(argResults!.rest);
}
