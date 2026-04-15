import 'package:cli_completion/cli_completion.dart';

import 'commands/add_auth_interceptor_command.dart';
import 'commands/add_entity_command.dart';
import 'commands/add_feature_command.dart';
import 'commands/add_network_module_command.dart';
import 'commands/add_repo_command.dart';
import 'commands/build_runner_command.dart';
import 'commands/init_command.dart';
import 'commands/regenerate_router_command.dart';
import 'commands/remove_feature_command.dart';
import 'commands/generate_localizations_command.dart';
import 'commands/add_vscode_config_command.dart';
import 'commands/generate_tools_command.dart';

class CleanHelperRunner extends CompletionCommandRunner<void> {
  CleanHelperRunner()
    : super(
        'clean-helper',
        'CLI tool for scaffolding Flutter clean architecture projects.',
      ) {
    addCommand(InitCommand());
    addCommand(AddFeatureCommand());
    addCommand(AddRepoCommand());
    addCommand(AddEntityCommand());
    addCommand(AddNetworkModuleCommand());
    addCommand(BuildRunnerCommand());
    addCommand(RemoveFeatureCommand());
    addCommand(RegenerateRouterCommand());
    addCommand(GenerateLocalizationsCommand());
    addCommand(AddAuthInterceptorCommand());
    addCommand(AddVscodeConfigCommand());
    addCommand(GenerateToolsCommand());
  }
}
