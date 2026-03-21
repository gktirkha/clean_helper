import 'package:args/command_runner.dart';

import '../../commands/add_feature.dart';

class AddFeatureCommand extends Command<void> {
  @override
  String get name => 'add_feature';

  @override
  String get description =>
      'Generate a new feature with full clean architecture structure.\n'
      'Usage: clean-helpers add_feature <feature_name>';

  @override
  String get invocation => '${runner?.executableName} $name <feature_name>';

  @override
  void run() => addFeature(argResults!.rest);
}
