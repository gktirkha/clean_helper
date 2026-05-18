import 'package:args/command_runner.dart';

import '../../commands/add_vscode_config.dart';

class AddVscodeConfigCommand extends Command<void> {
  @override
  String get name => 'add-vscode-config';

  @override
  String get description =>
      'Generate .vscode/extensions.json, launch.json, and tasks.json for the project.';

  @override
  void run() => addVscodeConfig();
}
