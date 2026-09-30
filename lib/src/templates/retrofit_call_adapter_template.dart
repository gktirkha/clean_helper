import '../functions/shared/sort_imports.dart';

String retrofitCallAdapterTemplate(String utilsImport) =>
    '''
${sortImports(["import 'package:fpdart/fpdart.dart';", "import 'package:retrofit/retrofit.dart';", "import '$utilsImport';"])}

class RetrofitCallAdapter<T>
    extends CallAdapter<Future<T>, TaskEither<Failure, T>> {
  @override
  TaskEither<Failure, T> adapt(Future<T> Function() call) {
    return safeExecuteTask(call);
  }
}
''';
