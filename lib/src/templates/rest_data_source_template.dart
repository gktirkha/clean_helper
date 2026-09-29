import '../functions/shared/camel_case.dart';
import '../functions/shared/sort_imports.dart';

String restDataSourceTemplate(
  String featureClass,
  String repoClass,
  String baseClass,
  String implClass,
  String feature,
  String repoName,
  String utilsImport, {
  String? networkImport,
  bool ignoreErrorLogger = false,
  bool addSample = false,
}) {
  final imports = sortImports([
    "import 'package:dio/dio.dart';",
    if (addSample) "import 'package:fpdart/fpdart.dart';",
    "import 'package:injectable/injectable.dart';",
    "import 'package:retrofit/error_logger.dart';",
    "import 'package:retrofit/http.dart';",
    "import '$utilsImport';",
    if (networkImport != null && networkImport != utilsImport)
      "import '$networkImport';",
  ]);

  final factory = ignoreErrorLogger
      ? '''
  // No ParseErrorLogger is registered by the configured packages, so it is
  // ignored here. Remove @ignoreParam once one is registered in DI.
  @factoryMethod
  factory $implClass(Dio dio, {@ignoreParam ParseErrorLogger? errorLogger}) = _$implClass;'''
      : '''
  @factoryMethod
  factory $implClass(Dio dio, {ParseErrorLogger? errorLogger}) = _$implClass;''';

  return addSample
      ? '''
$imports

import '../constants/${feature}_api_paths.dart';
import '../models/requests/${repoName}_request_model.dart';
import '../models/response/${repoName}_response_model.dart';
import '${repoName}_data_source_base.dart';

part 'rest_${repoName}_data_source.g.dart';

@RestApi(callAdapter: RetrofitCallAdapter)
@Injectable(as: $baseClass)
abstract class $implClass implements $baseClass {
$factory

  @override
  @GET(${featureClass}ApiPaths.${camelCase(repoName)})
  Future<Either<Failure, ${repoClass}ResponseModel>> get$repoClass(@Query('q') String? q);

  @override
  @POST(${featureClass}ApiPaths.${camelCase(repoName)})
  Future<Either<Failure, ${repoClass}ResponseModel>> post$repoClass(@Body() ${repoClass}RequestModel? requestModel);
}
'''
      : '''
$imports

import '${repoName}_data_source_base.dart';

part 'rest_${repoName}_data_source.g.dart';

@RestApi(callAdapter: RetrofitCallAdapter)
@Injectable(as: $baseClass)
abstract class $implClass implements $baseClass {
$factory
}
''';
}
