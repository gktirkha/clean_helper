import 'dart:io';

import '../../templates/analysis_options_template.dart';
import '../shared/fvm_exec.dart';
import '../shared/package_barrel_path.dart';
import '../shared/package_configs.dart';
import '../shared/run_command.dart';
import '../shared/write_file.dart';

/// Runs `flutter create --template package` for `packages/<name>`, removes
/// the scaffold files clean_helper doesn't use (README, CHANGELOG, LICENSE,
/// `.metadata`, `test/`, and `lib/<name>.dart` when the configured barrel is
/// elsewhere) and writes `analysis_options.yaml`.
void scaffoldPackage(PackageConfig package) {
  final dir = 'packages/${package.name}';

  runCommand([...fvmExec('flutter'), 'create', dir, '--template', 'package']);

  final defaultBarrel = '$dir/lib/${package.name}.dart';
  final filesToDelete = [
    '$dir/.metadata',
    '$dir/CHANGELOG.md',
    '$dir/LICENSE',
    '$dir/README.md',
    if (packageBarrelPath(package) != defaultBarrel) defaultBarrel,
  ];
  for (final path in filesToDelete) {
    final file = File(path);
    if (file.existsSync()) file.deleteSync();
  }
  final testDir = Directory('$dir/test');
  if (testDir.existsSync()) testDir.deleteSync(recursive: true);

  overwriteFile('$dir/analysis_options.yaml', analysisOptionsTemplate());
}
