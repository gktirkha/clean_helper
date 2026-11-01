/// Inserts [importLine] into [content] at its alphabetical place within its
/// own section (`dart:`, `package:` or relative), as `directives_ordering`
/// expects. With no import of that section yet, it goes after the last import.
String insertSortedImport(String content, String importLine) {
  String section(String line) => line.startsWith("import 'dart:")
      ? 'dart'
      : line.startsWith("import 'package:")
      ? 'package'
      : 'relative';

  final lines = content.split('\n');
  final target = section(importLine);
  var lastSameSection = -1;
  var lastImport = -1;

  for (var i = 0; i < lines.length; i++) {
    if (!lines[i].startsWith('import ')) continue;
    lastImport = i;
    if (section(lines[i]) != target) continue;
    if (lines[i].compareTo(importLine) > 0) {
      lines.insert(i, importLine);
      return lines.join('\n');
    }
    lastSameSection = i;
  }

  lines.insert(
    (lastSameSection != -1 ? lastSameSection : lastImport) + 1,
    importLine,
  );
  return lines.join('\n');
}
