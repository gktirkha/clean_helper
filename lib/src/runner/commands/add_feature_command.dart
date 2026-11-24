import 'package:args/command_runner.dart';

import '../../commands/add_feature.dart';

class AddFeatureCommand extends Command<void> {
  AddFeatureCommand() {
    argParser.addFlag(
      'di',
      abbr: 'd',
      negatable: false,
      help: 'Also generate a di/{feature}_di.dart injectable di.',
    );
    argParser.addOption(
      'bloc-name',
      valueHelp: 'name',
      help:
          'snake_case name for the generated bloc (default: the feature '
          'name).',
    );
    argParser.addFlag(
      'bloc',
      defaultsTo: true,
      help: 'Generate a bloc; --no-bloc makes a page without one.',
    );
  }

  @override
  String get name => 'add-feature';

  @override
  String get description =>
      'Generate a new feature with full clean architecture structure.';

  @override
  String get invocation => '${runner?.executableName} $name <feature-name>';

  @override
  String get usage =>
      'Generate a new feature with full clean architecture structure.\n\nUsage: ${runner?.executableName} $name <feature-name>';

  @override
  void run() => addFeature(
    argResults!.rest,
    withDi: argResults!['di'] as bool,
    blocName: argResults!['bloc-name'] as String?,
    withBloc: argResults!['bloc'] as bool,
  );
}
