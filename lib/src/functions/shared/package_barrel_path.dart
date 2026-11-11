import 'package_configs.dart';

/// Path of [package]'s barrel file, from its import URI:
/// `package:my_utils/src/all.dart` → `packages/my_utils/lib/src/all.dart`.
/// Falls back to `lib/<name>.dart` when the import isn't a URI into the
/// package itself.
String packageBarrelPath(PackageConfig package) {
  final prefix = 'package:${package.name}/';
  final file = package.import.startsWith(prefix)
      ? package.import.substring(prefix.length)
      : '${package.name}.dart';
  return 'packages/${package.name}/lib/$file';
}
