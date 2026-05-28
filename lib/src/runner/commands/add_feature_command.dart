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
  void run() => addFeature(argResults!.rest, withDi: argResults!['di'] as bool);
}
