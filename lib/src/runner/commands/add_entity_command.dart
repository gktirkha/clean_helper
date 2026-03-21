import 'package:args/command_runner.dart';

import '../../commands/add_entity.dart';

class AddEntityCommand extends Command<void> {
  @override
  String get name => 'add_entity';

  @override
  String get description =>
      'Generate a domain entity and a freezed data model.\n'
      'Usage: clean-helpers add_entity <feature|core> <entity_name> [domain folder name]';

  @override
  String get invocation =>
      '${runner?.executableName} $name <feature|core> <entity_name> [domain folder name]';

  @override
  void run() => addEntity(argResults!.rest);
}
