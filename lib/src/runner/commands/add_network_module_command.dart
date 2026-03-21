import 'package:args/command_runner.dart';

import '../../commands/add_network_module.dart';

class AddNetworkModuleCommand extends Command<void> {
  @override
  String get name => 'add_network_module';

  @override
  String get description =>
      'Set up the network layer: installs Dio, Retrofit, and related dependencies, '
      'and generates the network module files.';

  @override
  void run() => addNetworkModule();
}
