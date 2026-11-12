import 'package:args/command_runner.dart';

import '../../commands/add_vscode_extensions.dart';

class AddVscodeExtensionsCommand extends Command<void> {
  @override
  String get name => 'add-vscode-extensions';

  @override
  String get description =>
      'Add recommended VS Code extensions to .vscode/extensions.json in the '
      'current directory (keeps existing entries).';

  @override
  void run() => addVscodeExtensions();
}
