import 'package_configs.dart';

/// The folder workspace packages live in, relative to the project:
/// `foundation.dir`, else `foundation`. Trailing slashes and a leading `./` are
/// dropped.
String resolvePackagesDir() {
  final dir = (packagesDirConfig ?? '')
      .trim()
      .replaceFirst(RegExp(r'^\./'), '')
      .replaceFirst(RegExp(r'/+$'), '');
  return dir.isEmpty ? 'foundation' : dir;
}
