import 'dart:io';

/// Reads the scalar children of `clean-helper.<path...>` from `pubspec.yaml`
/// in the current directory, e.g. `['packages', 'utils']` →
/// `{'name': 'my_utils', 'import': 'package:my_utils/my_utils.dart'}`.
///
/// Comments and surrounding quotes are stripped. Returns an empty map if the
/// section is absent.
Map<String, String> readCleanHelperFields(List<String> path) {
  final pubspec = File('pubspec.yaml');
  if (!pubspec.existsSync()) return {};

  final target = ['clean-helper', ...path];
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
    if (value.isEmpty || stack.length != target.length + 1) continue;

    var inTarget = true;
    for (var i = 0; i < target.length; i++) {
      if (stack[i].$2 != target[i]) {
        inTarget = false;
        break;
      }
    }
    if (inTarget) fields[stack.last.$2] = value;
  }

  return fields;
}
