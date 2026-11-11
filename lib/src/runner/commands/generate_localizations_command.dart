import 'package:args/command_runner.dart';

import '../../commands/generate_localizations.dart';

class GenerateLocalizationsCommand extends Command<void> {
  @override
  String get name => 'generate-localizations';

  @override
  String get description =>
      'Run slang in the localization package (packages/<localization>).';

  @override
  void run() => runGenerateLocalizationsCommand();
}
