import 'dart:io';

import '../functions/shared/abort.dart';
import '../functions/shared/load_package_configs.dart';
import '../functions/shared/package_configs.dart';
import '../functions/shared/read_mono_repo_apps.dart';

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

  final utils = utilsPackageConfig;
  final network = networkPackageConfig;
  stdout.writeln();
  stdout.writeln('Packages (clean-helper.packages):');
  stdout.writeln(
    utils == null
        ? '  utils:    <app>_utils (default)'
        : '  utils:    ${utils.name}  (${utils.import})',
  );
  stdout.writeln(
    network == null
        ? '  network:  not configured (detected from lib/core/network/)'
        : '  network:  ${network.name}  (${network.import})',
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
    '  ${adapter?.name ?? 'RetrofitCallAdapter'}  '
    '(${adapter?.import ?? network?.import ?? utils?.import ?? '<app>_utils'})',
  );
}
