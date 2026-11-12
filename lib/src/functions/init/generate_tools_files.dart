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

void generateToolsFiles({bool overwrite = false}) {
  final write = overwrite ? overwriteFile : writeFile;
  String? local(String name) =>
      Directory('packages/$name').existsSync() ? 'packages/$name' : null;
  write(
    'tools/command_runner.dart',
    toolsCommandRunnerTemplate(fvmUse: monoRepoAppPath == null),
  );
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
