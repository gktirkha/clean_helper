import 'package:args/command_runner.dart';

import '../../commands/bootstrap.dart';

class BootstrapCommand extends Command<void> {
  @override
  String get name => 'bootstrap';

  @override
  String get description =>
      'Run fvm use (not in monorepo apps), flutter pub get, slang, and build_runner in the current project.';

  @override
  Future<void> run() => runBootstrapCommand();
}
