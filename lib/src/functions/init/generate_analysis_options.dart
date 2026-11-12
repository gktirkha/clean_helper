import '../../templates/analysis_options_include_template.dart';
import '../../templates/analysis_options_template.dart';
import '../shared/analysis_options_include.dart';
import '../shared/write_analysis_options.dart';

/// Writes `analysis_options.yaml` for the current project. Normally it holds
/// the full rules; with `use_root_analysis` in a monorepo app it includes the
/// workspace root's file instead, which gets the full rules. Existing files
/// are replaced unless `overwrite_analysis_options` is false.
void generateAnalysisOptions() {
  final include = analysisOptionsInclude('');
  if (include == null) {
    writeAnalysisOptions('analysis_options.yaml', analysisOptionsTemplate());
    return;
  }
  writeAnalysisOptions(include, analysisOptionsTemplate());
  writeAnalysisOptions(
    'analysis_options.yaml',
    analysisOptionsIncludeTemplate(include),
  );
}
