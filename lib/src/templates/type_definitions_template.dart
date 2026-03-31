String typeDefinitionsTemplate() => '''
typedef JsonDecodeFactory<T> = T Function(Map<String, dynamic> data);
''';
