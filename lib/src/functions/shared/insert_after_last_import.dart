String insertAfterLastImport(String content, String importLine) {
  final lines = content.split('\n');
  var lastImportIndex = -1;

  for (var i = 0; i < lines.length; i++) {
    if (lines[i].trimLeft().startsWith('import ')) {
      lastImportIndex = i;
    }
  }

  if (lastImportIndex == -1) {
    return '$importLine\n$content';
  }

  lines.insert(lastImportIndex + 1, importLine);
  return lines.join('\n');
}
