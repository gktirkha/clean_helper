import 'package_configs.dart';
import 'write_file.dart';

/// Writes an `analysis_options.yaml` at [path]: replaces an existing file
/// unless `overwrite_analysis_options` is false, in which case it's kept.
void writeAnalysisOptions(String path, String content) {
  final write = overwriteAnalysisOptionsConfig ? overwriteFile : writeFile;
  write(path, content);
}
