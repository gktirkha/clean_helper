String listToModelListTemplate() => '''
import 'type_definitions.dart';

List<T> listToModelList<T>(final List list, JsonDecodeFactory<T> decoder) => [
  ...list.map((e) => decoder(e)),
];
''';
