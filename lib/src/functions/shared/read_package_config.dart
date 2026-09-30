import 'package_configs.dart';
import 'read_clean_helper_fields.dart';

/// Reads `clean-helper.packages.<key>` from `pubspec.yaml` in the current
/// directory:
///
/// ```yaml
/// clean-helper:
///   packages:
///     network:
///       name: my_network
///       import: package:my_network/my_network_module.dart
/// ```
///
/// `import` defaults to `package:<name>/<name>.dart`; `name` defaults to the
/// package named in `import`. Returns null if neither is set.
PackageConfig? readPackageConfig(String key) {
  final fields = readCleanHelperFields(['packages', key]);
  final import = fields['import'];
  final name =
      fields['name'] ??
      (import == null
          ? null
          : RegExp(r'^package:([^/]+)/').firstMatch(import)?.group(1));
  if (name == null) return null;

  return (name: name, import: import ?? 'package:$name/$name.dart');
}
