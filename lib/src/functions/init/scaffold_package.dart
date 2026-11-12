import 'dart:io';

import '../../templates/analysis_options_include_template.dart';
import '../shared/analysis_options_include.dart';
import '../shared/fvm_exec.dart';
import '../shared/package_barrel_path.dart';
import '../shared/package_configs.dart';
import '../shared/run_command.dart';
import '../shared/write_file.dart';

/// Runs `flutter create --template package --no-pub` for `<parentDir>/<name>`, removes
/// the scaffold files clean_helper doesn't use (README, CHANGELOG, LICENSE,
/// `.metadata`, `test/`, and `lib/<name>.dart` when the configured barrel is
/// elsewhere) and writes an `analysis_options.yaml` that includes the
/// project's (or, with `use_root_analysis`, the workspace root's) file. That
/// one is always written: the only existing file is flutter create's default.
void scaffoldPackage(PackageConfig package, {String parentDir = 'packages'}) {
  final dir = '$parentDir/${package.name}';

  // Inside a workspace, flutter create fails when the parent folder doesn't
  // exist yet ("failed to list directory"), so create it first.
  Directory(parentDir).createSync(recursive: true);
  // --no-pub: the package isn't in the enclosing workspace yet, and resolving
  // that workspace now fails on any member that doesn't exist. Callers run
  // pub get once the packages are listed under `workspace:`.
  runCommand([
    ...fvmExec('flutter'),
    'create',
    dir,
    '--template',
    'package',
    '--no-pub',
  ]);

  final defaultBarrel = '$dir/lib/${package.name}.dart';
  final filesToDelete = [
    '$dir/.metadata',
    '$dir/CHANGELOG.md',
    '$dir/LICENSE',
    '$dir/README.md',
    if (packageBarrelPath(package, parentDir) != defaultBarrel) defaultBarrel,
  ];
  for (final path in filesToDelete) {
    final file = File(path);
    if (file.existsSync()) file.deleteSync();
  }
  final testDir = Directory('$dir/test');
  if (testDir.existsSync()) testDir.deleteSync(recursive: true);

  overwriteFile(
    '$dir/analysis_options.yaml',
    analysisOptionsIncludeTemplate(analysisOptionsInclude(dir)!),
  );
}
