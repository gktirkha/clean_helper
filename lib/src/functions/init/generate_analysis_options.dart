import '../shared/write_file.dart';
import '../../templates/analysis_options_template.dart';

void generateAnalysisOptions() {
  overwriteFile('analysis_options.yaml', analysisOptionsTemplate());
}
