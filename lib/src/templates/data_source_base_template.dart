import '../functions/shared/sort_imports.dart';

String dataSourceBaseTemplate(
  String className,
  String repoName,
  String utilsImport, {
  bool addSample = false,
}) => addSample
    ? '''
${sortImports(["import 'package:fpdart/fpdart.dart';", "import '$utilsImport';"])}

import '../models/requests/${repoName}_request_model.dart';
import '../models/response/${repoName}_response_model.dart';

abstract interface class ${className}DataSourceBase {
  Future<Either<Failure, ${className}ResponseModel>> get$className(String? q);
  Future<Either<Failure, ${className}ResponseModel>> post$className(${className}RequestModel? requestModel);
}
'''
    : '''
abstract interface class ${className}DataSourceBase {
}
''';
