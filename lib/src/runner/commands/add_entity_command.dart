import 'package:args/command_runner.dart';

import '../../commands/add_entity.dart';

class AddEntityCommand extends Command<void> {
  @override
  String get name => 'add_entity';

  @override
  String get description => 'Generate a domain entity and a freezed data model.';

  @override
  String get invocation =>
      '${runner?.executableName} $name <feature|core> <entity_name> [domain folder name]';

  @override
  String get usage =>
      'Generate a domain entity and a freezed data model.\n\nUsage: ${runner?.executableName} $name <feature|core> <entity_name> [domain folder name]';

  @override
  void run() => addEntity(argResults!.rest);
}
