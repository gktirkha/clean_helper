import 'package:args/command_runner.dart';

import '../../commands/add_repo.dart';

class AddRepoCommand extends Command<void> {
  AddRepoCommand() {
    argParser.addFlag(
      'no-rest',
      negatable: false,
      help: 'Skip generating the REST datasource and API paths.',
    );
    argParser.addFlag(
      'add-sample',
      negatable: false,
      help:
          'Generate sample get/post methods and request/response model files.',
    );
  }

  @override
  String get name => 'add-repo';

  @override
  String get description =>
      'Generate a repository interface (domain) and implementation (data).';

  @override
  String get invocation =>
      '${runner?.executableName} $name <feature> <repo_name> [--no-rest] [--add-sample]';

  @override
  String get usage =>
      'Generate a repository interface (domain) and implementation (data).\n\nUsage: ${runner?.executableName} $name <feature> <repo_name> [--no-rest] [--add-sample]';

  @override
  void run() => addRepo(
    argResults!.rest,
    noRest: argResults!['no-rest'] as bool,
    addSample: argResults!['add-sample'] as bool,
  );
}
