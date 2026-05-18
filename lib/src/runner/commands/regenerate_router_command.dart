import 'package:args/command_runner.dart';

import '../../commands/regenerate_router.dart';

class RegenerateRouterCommand extends Command<void> {
  @override
  String get name => 'regenerate-router';

  @override
  String get description =>
      'Scan all features and regenerate app_router_module.dart from scratch.';

  @override
  String get usage =>
      'Scan all features and regenerate app_router_module.dart from scratch.\n\nUsage: ${runner?.executableName} $name';

  @override
  void run() => regenerateRouter();
}
