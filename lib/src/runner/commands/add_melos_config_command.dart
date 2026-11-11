import 'package:args/command_runner.dart';

import '../../commands/add_melos_config.dart';

class AddMelosConfigCommand extends Command<void> {
  @override
  String get name => 'add-melos-config';

  @override
  String get description =>
      'Add melos as a dev dependency and a melos: config block (bootstrap/clean hooks and scripts) to the root pubspec.yaml.';

  @override
  void run() => addMelosConfig();
}
