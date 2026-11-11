import 'dart:io';

import '../functions/shared/abort.dart';
import '../functions/shared/load_package_configs.dart';
import '../functions/shared/package_configs.dart';
import '../functions/shared/read_mono_repo_apps.dart';
import '../functions/shared/resolve_call_adapter_name.dart';
import '../functions/shared/resolve_slang_settings.dart';

// Does NOT call ensurePubspec() — that would trigger project selection before
// we can print the list. Pubspec presence is checked directly instead.
void listMonoRepoApps() {
  if (!File('pubspec.yaml').existsSync()) {
    abort('pubspec.yaml not found. Run this tool from the project root.');
  }

  loadPackageConfigs();
  final apps = readMonoRepoApps();

  if (apps == null) {
    stdout.writeln('No mono-repo apps configured.');
    stdout.writeln(
      'Add a clean-helper section to pubspec.yaml to declare your apps:',
    );
    stdout.writeln();
    stdout.writeln('  clean-helper:');
    stdout.writeln('    mono_repo_apps:');
    stdout.writeln('      - apps/app1');
    stdout.writeln('      - apps/app2');
  } else {
    stdout.writeln('Detected mono-repo apps (${apps.length}):');
    for (var i = 0; i < apps.length; i++) {
      final label = apps[i].split('/').last;
      stdout.writeln('  ${i + 1}. $label  (${apps[i]})');
    }
  }

  String describe(PackageConfig? p, String fallback) => p == null
      ? fallback
      : '${p.name}  (${p.import})${p.create ? '' : '  — not created'}';

  final network = networkPackageConfig;
  stdout.writeln();
  stdout.writeln('Packages (clean-helper.packages):');
  stdout.writeln(
    '  utils:         ${describe(utilsPackageConfig, '<app>_utils (default)')}',
  );
  stdout.writeln(
    '    module_name:       ${utilsModuleNameConfig ?? '<UtilsPascal>Module (default)'}',
  );
  stdout.writeln(
    '    call_adapter_name: ${callAdapterNameConfig ?? 'not set'}',
  );
  stdout.writeln(
    '  localization:  ${describe(localizationPackageConfig, '<app>_localization (default)')}',
  );
  for (final e in resolveSlangSettings().entries) {
    final source = slangSettingsConfig.containsKey(e.key) ? '' : ' (default)';
    stdout.writeln('    ${e.key}: ${e.value}$source');
  }
  stdout.writeln(
    '  router:        ${describe(routerPackageConfig, 'clean_router (default)')}',
  );
  stdout.writeln(
    network == null
        ? '  network:       not configured (detected from lib/core/network/)'
        : '  network:       ${network.name}  (${network.import})',
  );

  stdout.writeln(
    '  use_root_analysis: $useRootAnalysisConfig'
    '${useRootAnalysisConfig ? '' : ' (default — packages include the nearest project)'}',
  );

  stdout.writeln();
  stdout.writeln(
    'Result type (clean-helper.result_type): '
    '${resultTypeConfig ?? 'task_either (default)'}',
  );

  final adapter = retrofitCallAdapterConfig;
  stdout.writeln();
  stdout.writeln('Retrofit call adapter (clean-helper.retrofit_call_adapter):');
  stdout.writeln(
    '  ${resolveCallAdapterName()}  '
    '(${adapter?.import ?? network?.import ?? 'lib/core/network/utils/retrofit_call_adapter.dart'})',
  );
}
