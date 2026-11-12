import 'dart:io';

import '../functions/vscode/write_vscode_extensions.dart';

// Does NOT call ensurePubspec() — `.vscode/` belongs to the folder opened in
// VS Code (the monorepo root in a monorepo), and ensurePubspec() would switch
// into an app first.

/// Adds the recommended VS Code extensions to `.vscode/extensions.json` in the
/// current directory.
void addVscodeExtensions() {
  stdout.writeln('🖥️  Adding VS Code extension recommendations...');
  writeVscodeExtensions();
  stdout.writeln('✅ Done.');
}
