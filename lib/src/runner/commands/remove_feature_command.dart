import 'package:args/command_runner.dart';

import '../../commands/remove_feature.dart';

class RemoveFeatureCommand extends Command<void> {
  @override
  String get name => 'remove_feature';

  @override
  String get description =>
      'Remove a feature and deregister its router.\n'
      'Usage: clean-helper remove_feature <feature_name>';

  @override
  String get invocation => '${runner?.executableName} $name <feature_name>';

  @override
  void run() => removeFeature(argResults!.rest);
}
