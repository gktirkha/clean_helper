import 'package:cli_completion/cli_completion.dart';

import 'commands/add_entity_command.dart';
import 'commands/add_feature_command.dart';
import 'commands/add_repo_command.dart';
import 'commands/init_command.dart';

class CleanHelpersRunner extends CompletionCommandRunner<void> {
  CleanHelpersRunner()
    : super(
        'clean-helpers',
        'CLI tool for scaffolding Flutter clean architecture projects.',
      ) {
    addCommand(InitCommand());
    addCommand(AddFeatureCommand());
    addCommand(AddRepoCommand());
    addCommand(AddEntityCommand());
  }
}
