import 'dart:convert';
import 'dart:io';

import '../../templates/vscode_extensions_template.dart';
import '../shared/write_file.dart';

/// Writes `.vscode/extensions.json` with [vscodeRecommendedExtensions], or adds
/// the missing ones to an existing file's `recommendations`, keeping its
/// entries. A file that isn't plain JSON (e.g. has comments) is left alone.
void writeVscodeExtensions() {
  const path = '.vscode/extensions.json';
  final file = File(path);

  if (!file.existsSync()) {
    overwriteFile(path, vscodeExtensionsTemplate(vscodeRecommendedExtensions));
    return;
  }

  final Map<String, dynamic> json;
  try {
    json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  } on FormatException {
    stderr.writeln(
      '⚠️  $path isn\'t plain JSON (comments?) — add these recommendations '
      'yourself: ${vscodeRecommendedExtensions.join(', ')}',
    );
    return;
  }

  final existing = [
    ...((json['recommendations'] as List?) ?? const []).cast<String>(),
  ];
  final lower = existing.map((e) => e.toLowerCase()).toSet();
  final missing = [
    for (final id in vscodeRecommendedExtensions)
      if (!lower.contains(id.toLowerCase())) id,
  ];
  if (missing.isEmpty) {
    stdout.writeln('  ⏭  All recommendations already in $path');
    return;
  }

  json['recommendations'] = [...existing, ...missing];
  overwriteFile(
    path,
    '${const JsonEncoder.withIndent('    ').convert(json)}\n',
  );
  stdout.writeln('  ➕ Added to $path: ${missing.join(', ')}');
}
