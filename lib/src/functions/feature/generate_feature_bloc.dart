import '../shared/pascal_case.dart';
import '../shared/write_file.dart';
import '../../templates/feature_bloc_template.dart';
import '../../templates/feature_event_template.dart';
import '../../templates/feature_state_template.dart';

void generateFeatureBloc(String feature, String basePath) {
  final className = pascalCase(feature);
  final blocPath = '$basePath/presentation/bloc/$feature';

  writeFile(
    '$blocPath/${feature}_bloc.dart',
    featureBlocTemplate(feature, className),
  );
  writeFile(
    '$blocPath/${feature}_event.dart',
    featureEventTemplate(feature, className),
  );
  writeFile(
    '$blocPath/${feature}_state.dart',
    featureStateTemplate(feature, className),
  );
}
