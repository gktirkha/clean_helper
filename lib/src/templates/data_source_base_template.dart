String dataSourceBaseTemplate(
  String className,
  String repoName, {
  bool addSample = false,
}) => addSample
    ? '''
import 'package:fpdart/fpdart.dart';

import '../../../../core/domain/failures/failure.dart';
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
