import 'package:args/command_runner.dart';

import '../../commands/generate_localizations.dart';

class GenerateLocalizationsCommand extends Command<void> {
  @override
  String get name => 'generate_localizations';

  @override
  String get description =>
      'Generate locales using slang in the current Flutter project.';

  @override
  void run() => runGenerateLocalizationsCommand(argResults!.rest);
}
