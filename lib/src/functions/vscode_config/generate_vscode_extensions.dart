import 'dart:io';

import '../../templates/vscode_extensions_template.dart';
import '../shared/write_file.dart';

void generateVscodeExtensions() {
  const path = '.vscode/extensions.json';
  writeFile(path, vscodeExtensionsTemplate());
  stdout.writeln('  ✏️  Written: $path');
}
