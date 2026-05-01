import 'package:args/command_runner.dart';

import '../../commands/list_mono_repo_apps.dart';

class ListMonoRepoAppsCommand extends Command<void> {
  @override
  String get name => 'list_mono_repo_apps';

  @override
  String get description =>
      'List all mono-repo apps declared in pubspec.yaml under clean-helper.mono_repo_apps.';

  @override
  void run() => listMonoRepoApps();
}
