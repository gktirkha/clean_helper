import 'package_configs.dart';

/// Relative prefix from [package]'s barrel back to its `lib/`: `''` for
/// `lib/<name>.dart`, `'../'` for `lib/src/<file>.dart`, and so on. Barrel
/// exports are written as `'$prefix' 'src/…'`.
String packageBarrelPrefix(PackageConfig package) {
  final prefix = 'package:${package.name}/';
  final inLib = package.import.startsWith(prefix)
      ? package.import.substring(prefix.length)
      : '${package.name}.dart';
  return '../' * '/'.allMatches(inLib).length;
}
