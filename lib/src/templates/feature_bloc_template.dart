String featureBlocTemplate(String feature, String className) =>
    '''
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
''';
