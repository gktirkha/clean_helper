import 'dart:io';

import 'package_configs.dart';

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
  final pubspec = File('pubspec.yaml');
  if (!pubspec.existsSync()) return null;

  final stack = <(int, String)>[];
  final fields = <String, String>{};

  for (final raw in pubspec.readAsLinesSync()) {
    final line = raw.replaceFirst(RegExp(r'\s+#.*$'), '');
    final trimmed = line.trim();
    if (trimmed.isEmpty || trimmed.startsWith('#') || trimmed.startsWith('-')) {
      continue;
    }

    final colon = trimmed.indexOf(':');
    if (colon <= 0) continue;

    final indent = line.length - line.trimLeft().length;
    while (stack.isNotEmpty && stack.last.$1 >= indent) {
      stack.removeLast();
    }
    stack.add((indent, trimmed.substring(0, colon).trim()));

    final value = trimmed
        .substring(colon + 1)
        .trim()
        .replaceAll(RegExp('''^['"]|['"]\$'''), '');
    if (stack.length == 4 &&
        stack[0].$2 == 'clean-helper' &&
        stack[1].$2 == 'packages' &&
        stack[2].$2 == key &&
        value.isNotEmpty) {
      fields[stack[3].$2] = value;
    }
  }

  final import = fields['import'];
  final name =
      fields['name'] ??
      (import == null
          ? null
          : RegExp(r'^package:([^/]+)/').firstMatch(import)?.group(1));
  if (name == null) return null;

  return (name: name, import: import ?? 'package:$name/$name.dart');
}
