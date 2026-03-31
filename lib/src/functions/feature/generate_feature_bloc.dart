import '../shared/pascal_case.dart';
import '../shared/write_file.dart';

void generateFeatureBloc(String feature, String basePath) {
  final className = pascalCase(feature);
  final blocPath = '$basePath/presentation/bloc/$feature';

  writeFile('$blocPath/${feature}_bloc.dart', '''
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part '${feature}_bloc.freezed.dart';
part '${feature}_event.dart';
part '${feature}_state.dart';

@lazySingleton
class ${className}Bloc extends Bloc<${className}Event, ${className}State> {
  ${className}Bloc() : super(const .initial()) {
    on<${className}Event>((event, emit) {});
  }
}
''');

  writeFile('$blocPath/${feature}_event.dart', '''
part of '${feature}_bloc.dart';

@freezed
abstract class ${className}Event with _\$${className}Event {
  const factory ${className}Event.started() = _Started;
}
''');

  writeFile('$blocPath/${feature}_state.dart', '''
part of '${feature}_bloc.dart';

@freezed
abstract class ${className}State with _\$${className}State {
  const factory ${className}State.initial() = _Initial;
}
''');
}
