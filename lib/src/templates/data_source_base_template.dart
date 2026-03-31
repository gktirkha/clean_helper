String dataSourceBaseTemplate(String className, String repoName) =>
    '''
import '../models/requests/${repoName}_request_model.dart';
import '../models/response/${repoName}_response_model.dart';

abstract interface class ${className}DataSourceBase {
  Future<${className}ResponseModel> get$className();
  Future<${className}ResponseModel> post$className(${className}RequestModel? requestModel);
}
''';
