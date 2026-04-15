import '../functions/init/generate_tools_files.dart';
import '../functions/shared/ensure_pubspec.dart';

void generateTools({bool overwrite = false}) {
  ensurePubspec();
  generateToolsFiles(overwrite: overwrite);
}
