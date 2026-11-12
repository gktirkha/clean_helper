import 'package:args/command_runner.dart';

import '../../commands/list_mono_repo_apps.dart';

class ListMonoRepoAppsCommand extends Command<void> {
  @override
  String get name => 'list-mono-repo-apps';

  @override
  String get description =>
      'List the mono-repo apps and show how every clean-helper config key '
      'resolves.';

  @override
  void run() => listMonoRepoApps();
}
