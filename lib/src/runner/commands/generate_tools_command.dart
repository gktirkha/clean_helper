import 'package:args/command_runner.dart';

import '../../commands/generate_tools.dart';

class GenerateToolsCommand extends Command<void> {
  @override
  String get name => 'generate_tools';

  @override
  String get description => 'Generate tools/ scripts in the current project.';

  @override
  void run() => generateTools();
}
