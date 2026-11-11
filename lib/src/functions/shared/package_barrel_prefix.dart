import 'package_barrel_path.dart';
import 'package_configs.dart';

/// Relative prefix from [package]'s barrel back to its `lib/`: `''` for
/// `lib/<name>.dart`, `'../'` for `lib/src/<file>.dart`, and so on. Barrel
/// exports are written as `'$prefix' 'src/…'`.
String packageBarrelPrefix(PackageConfig package) {
  final inLib = packageBarrelPath(package)
      .substring('packages/${package.name}/lib/'.length);
  return '../' * ('/'.allMatches(inLib).length);
}
