import 'package:args/command_runner.dart';

import '../../commands/create_packages.dart';

class CreatePackagesCommand extends Command<void> {
  CreatePackagesCommand() {
    argParser.addOption(
      'dir',
      help:
          'Directory to create the packages in, relative to the current '
          'directory.',
      defaultsTo: 'packages',
      valueHelp: 'path',
    );
  }

  @override
  String get name => 'create-packages';

  @override
  String get description =>
      'Create the utils, localization, router and (if configured) network '
      'packages from clean-helper.packages, ignoring create:, and add them '
      'to workspace:.';

  @override
  void run() => createPackages(dir: argResults!['dir'] as String?);
}
