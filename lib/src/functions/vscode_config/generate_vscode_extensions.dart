import 'dart:io';

import '../shared/write_file.dart';
import '../../templates/vscode_extensions_template.dart';

void generateVscodeExtensions() {
  const path = '.vscode/extensions.json';
  writeFile(path, vscodeExtensionsTemplate());
  stdout.writeln('  📄 $path');
}
