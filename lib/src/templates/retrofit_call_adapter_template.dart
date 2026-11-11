import '../functions/shared/sort_imports.dart';

String retrofitCallAdapterTemplate(String utilsImport, String className) =>
    '''
${sortImports(["import 'package:fpdart/fpdart.dart';", "import 'package:retrofit/retrofit.dart';", "import '$utilsImport';"])}

class $className<T>
    extends CallAdapter<Future<T>, TaskEither<Failure, T>> {
  @override
  TaskEither<Failure, T> adapt(Future<T> Function() call) {
    return safeExecuteTask(call);
  }
}
''';
