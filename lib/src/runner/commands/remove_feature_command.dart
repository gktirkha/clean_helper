import 'package:args/command_runner.dart';

import '../../commands/remove_feature.dart';

class RemoveFeatureCommand extends Command<void> {
  @override
  String get name => 'remove_feature';

  @override
  String get description => 'Remove a feature and deregister its router.';

  @override
  String get invocation => '${runner?.executableName} $name <feature_name>';

  @override
  String get usage =>
      'Remove a feature and deregister its router.\n\nUsage: ${runner?.executableName} $name <feature_name>';

  @override
  void run() => removeFeature(argResults!.rest);
}
