import 'dart:io';

import '../../templates/tools_bootstrap_template.dart';
import '../../templates/tools_build_android_template.dart';
import '../../templates/tools_build_config_template.dart';
import '../../templates/tools_clean_template.dart';
import '../../templates/tools_command_runner_template.dart';
import '../../templates/tools_write_key_properties_template.dart';
import '../shared/package_configs.dart';
import '../shared/resolve_localization_package.dart';
import '../shared/resolve_network_package.dart';
import '../shared/resolve_utils_package.dart';
import '../shared/write_file.dart';

/// Writes `tools/`. Skipped in a monorepo app: the workspace root runs those
/// jobs (e.g. through melos), and the Flutter version is pinned there.
void generateToolsFiles({bool overwrite = false}) {
  if (monoRepoAppPath != null) {
    stdout.writeln(
      '  ⏭  Monorepo app — tools/ not generated '
      '(run these jobs from the workspace root, e.g. add-melos-config)',
    );
    return;
  }

  final write = overwrite ? overwriteFile : writeFile;
  String? local(String name) =>
      Directory('packages/$name').existsSync() ? 'packages/$name' : null;
  write('tools/command_runner.dart', toolsCommandRunnerTemplate());
  write('tools/clean.dart', toolsCleanTemplate());
  write(
    'tools/bootstrap.dart',
    toolsBootstrapTemplate(
      localizationDir: local(resolveLocalizationPackage().name),
      buildDirs: [
        for (final name in [
          resolveUtilsPackage().name,
          resolveNetworkPackage().name,
        ])
          ?local(name),
      ],
    ),
  );
  write('tools/write_key_properties.dart', toolsWriteKeyPropertiesTemplate());
  write('tools/build_android.dart', toolsBuildAndroidTemplate());
  write('tools/config/android_build_config.json', toolsBuildConfigTemplate());
  stdout.writeln('🔧 Tools generated');
  stdout.writeln();
}
