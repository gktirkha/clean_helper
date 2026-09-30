import '../functions/shared/sort_imports.dart';

String dataSourceBaseTemplate(
  String className,
  String repoName,
  String utilsImport, {
  bool addSample = false,
  bool taskEither = true,
}) {
  final result = taskEither
      ? 'TaskEither<Failure, ${className}ResponseModel>'
      : 'Future<Either<Failure, ${className}ResponseModel>>';

  return addSample
      ? '''
${sortImports(["import 'package:fpdart/fpdart.dart';", "import '$utilsImport';"])}

import '../models/requests/${repoName}_request_model.dart';
import '../models/response/${repoName}_response_model.dart';

abstract interface class ${className}DataSourceBase {
  $result get$className(String? q);
  $result post$className(${className}RequestModel? requestModel);
}
'''
      : '''
abstract interface class ${className}DataSourceBase {
}
''';
}
