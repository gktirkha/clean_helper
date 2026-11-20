import 'package:args/command_runner.dart';

import '../../commands/add_agent_context.dart';

class AddAgentContextCommand extends Command<void> {
  @override
  String get name => 'add-agent-context';

  @override
  String get description =>
      'Write .agents/ (rules, architecture, one file per clean-helper command) '
      'and AGENTS.md / CLAUDE.md pointers for AI coding tools.';

  @override
  void run() => addAgentContext();
}
