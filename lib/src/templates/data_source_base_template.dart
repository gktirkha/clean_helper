String dataSourceBaseTemplate(
  String className,
  String repoName,
  String utilsPackageName, {
  bool addSample = false,
}) => addSample
    ? '''
import 'package:fpdart/fpdart.dart';
import 'package:$utilsPackageName/$utilsPackageName.dart';

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
