import 'package:args/command_runner.dart';

import '../../commands/init.dart';

class InitCommand extends Command<void> {
  @override
  String get name => 'init';

  @override
  String get description =>
      'Scaffold a Flutter clean architecture project in the current directory.';

  @override
  void run() => runInit();
}
