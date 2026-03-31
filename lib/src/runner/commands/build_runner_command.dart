import 'package:args/command_runner.dart';

import '../../commands/build_runner.dart';

class BuildRunnerCommand extends Command<void> {
  @override
  String get name => 'build_runner';

  @override
  String get description => 'Run build_runner in the current Flutter project.';

  @override
  String get invocation => '${runner?.executableName} $name [clean|build]';

  @override
  String get usage =>
      'Run build_runner in the current Flutter project.\n\nUsage: ${runner?.executableName} $name [clean|build] (default: build)';

  @override
  void run() => runBuildRunnerCommand(argResults!.rest);
}
