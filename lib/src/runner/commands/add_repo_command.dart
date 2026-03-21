import 'package:args/command_runner.dart';

import '../../commands/add_repo.dart';

class AddRepoCommand extends Command<void> {
  @override
  String get name => 'add_repo';

  @override
  String get description =>
      'Generate a repository interface (domain) and implementation (data).\n'
      'Usage: clean-helper add_repo <feature|core> <repo_name>';

  @override
  String get invocation =>
      '${runner?.executableName} $name <feature|core> <repo_name>';

  @override
  void run() => addRepo(argResults!.rest);
}
