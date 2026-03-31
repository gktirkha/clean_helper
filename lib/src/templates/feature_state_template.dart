String featureStateTemplate(String feature, String className) =>
    '''
part of '${feature}_bloc.dart';

@freezed
abstract class ${className}State with _\$${className}State {
  const factory ${className}State.initial() = _Initial;
}
''';
