import '../../templates/analysis_options_include_template.dart';
import '../../templates/analysis_options_template.dart';
import '../shared/analysis_options_include.dart';
import '../shared/write_file.dart';

/// Writes `analysis_options.yaml` for the current project. Normally it holds
/// the full rules; with `use_root_analysis` in a monorepo app it includes the
/// workspace root's file instead, which is created there if missing.
void generateAnalysisOptions() {
  final include = analysisOptionsInclude('');
  if (include == null) {
    overwriteFile('analysis_options.yaml', analysisOptionsTemplate());
    return;
  }
  writeFile(include, analysisOptionsTemplate());
  overwriteFile(
    'analysis_options.yaml',
    analysisOptionsIncludeTemplate(include),
  );
}
