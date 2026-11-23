import 'package:args/command_runner.dart';

import '../../commands/add_agent_context.dart';

class AddAgentContextCommand extends Command<void> {
  AddAgentContextCommand() {
    argParser.addFlag(
      'overwrite',
      abbr: 'o',
      negatable: false,
      help:
          'Rewrite the generated .agents/ files that already exist (rules, '
          'architecture, command docs). Your own .agents/*.md files and '
          'AGENTS.md / CLAUDE.md are never touched.',
    );
  }

  @override
  String get name => 'add-agent-context';

  @override
  String get description =>
      'Write .agents/ (rules, architecture, one file per clean-helper command) '
      'and AGENTS.md / CLAUDE.md pointers for AI coding tools. Existing files '
      'are kept unless --overwrite.';

  @override
  void run() => addAgentContext(overwrite: argResults!['overwrite'] as bool);
}
