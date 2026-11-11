import 'package_configs.dart';
import 'read_clean_helper_fields.dart';

/// Reads `clean-helper.packages.<key>` from `pubspec.yaml` in the current
/// directory:
///
/// ```yaml
/// clean-helper:
///   packages:
///     utils:
///       name: my_utils
///       import: package:my_utils/my_utils.dart
///       create: true
/// ```
///
/// `import` defaults to `package:<name>/<name>.dart`; `name` defaults to the
/// package named in `import`; `create` defaults to true. Returns null if
/// neither `name` nor `import` is set.
PackageConfig? readPackageConfig(String key) {
  final fields = readCleanHelperFields(['packages', key]);
  final import = fields['import'];
  final name =
      fields['name'] ??
      (import == null
          ? null
          : RegExp(r'^package:([^/]+)/').firstMatch(import)?.group(1));
  if (name == null) return null;

  return (
    name: name,
    import: import ?? 'package:$name/$name.dart',
    create: fields['create']?.toLowerCase() != 'false',
  );
}
