import 'package:args/command_runner.dart';

import '../../commands/add_network_module.dart';

class AddNetworkModuleCommand extends Command<void> {
  @override
  String get name => 'add-network-module';

  @override
  String get description =>
      'Create the network package (Dio, NetworkConfig, interceptors) and '
      'wire the app to it.';

  @override
  void run() => addNetworkModule();
}
