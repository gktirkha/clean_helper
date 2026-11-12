import 'package:args/command_runner.dart';

import '../../commands/add_config.dart';

class AddConfigCommand extends Command<void> {
  @override
  String get name => 'add-config';

  @override
  String get description =>
      'Append a commented clean-helper: block with every config key to the '
      'current pubspec.yaml (the monorepo root in a monorepo).';

  @override
  void run() => addConfig();
}
