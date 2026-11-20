import 'package:args/command_runner.dart';

import '../../commands/create_foundation.dart';

class CreateFoundationCommand extends Command<void> {
  CreateFoundationCommand() {
    argParser.addOption(
      'dir',
      help:
          'Directory to create the packages in, relative to the current '
          'directory. Defaults to clean-helper.foundation.dir (foundation).',
      valueHelp: 'path',
    );
  }

  @override
  String get name => 'create-foundation';

  @override
  String get description =>
      'Create the utils, localization, router, theme and (if configured) network '
      'packages from clean-helper.foundation, ignoring create:, and add them '
      'to workspace:.';

  @override
  void run() => createFoundation(dir: argResults!['dir'] as String?);
}
