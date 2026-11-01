/// Inserts a `package:` [importLine] into [content] at its alphabetical place
/// among the existing `package:` imports, as `directives_ordering` expects.
/// Falls back to the top of the file when there are none.
String insertPackageImport(String content, String importLine) {
  final lines = content.split('\n');
  var lastPackageIndex = -1;

  for (var i = 0; i < lines.length; i++) {
    if (!lines[i].startsWith("import 'package:")) continue;
    if (lines[i].compareTo(importLine) > 0) {
      lines.insert(i, importLine);
      return lines.join('\n');
    }
    lastPackageIndex = i;
  }

  lines.insert(lastPackageIndex + 1, importLine);
  return lines.join('\n');
}
