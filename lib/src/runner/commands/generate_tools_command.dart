import 'package:args/command_runner.dart';

import '../../commands/generate_tools.dart';

class GenerateToolsCommand extends Command<void> {
  GenerateToolsCommand() {
    argParser.addFlag(
      'overwrite',
      abbr: 'o',
      negatable: false,
      help: 'Overwrite existing tool files.',
    );
  }

  @override
  String get name => 'generate-tools';

  @override
  String get description => 'Generate tools/ scripts in the current project.';

  @override
  void run() => generateTools(overwrite: argResults!['overwrite'] as bool);
}
