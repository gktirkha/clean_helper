String featureEventTemplate(String feature, String className) =>
    '''
part of '${feature}_bloc.dart';

@freezed
abstract class ${className}Event with _\$${className}Event {
  const factory ${className}Event.started() = _Started;
}
''';
