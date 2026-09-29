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
  String callAdapter = 'RetrofitCallAdapter',
  String? adapterImport,
  bool ignoreErrorLogger = false,
  bool addSample = false,
  bool taskEither = true,
}) {
  final result = taskEither
      ? 'TaskEither<Failure, ${repoClass}ResponseModel>'
      : 'Future<Either<Failure, ${repoClass}ResponseModel>>';

  final imports = sortImports([
    "import 'package:dio/dio.dart';",
    if (addSample) "import 'package:fpdart/fpdart.dart';",
    "import 'package:injectable/injectable.dart';",
    "import 'package:retrofit/retrofit.dart';",
    "import '$utilsImport';",
    if (adapterImport != null && adapterImport != utilsImport)
      "import '$adapterImport';",
  ]);

  final factory = ignoreErrorLogger
      ? '''
  // The configured network package may not register a ParseErrorLogger, and
  // resolving an unregistered one throws. Remove @ignoreParam once it does.
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

@RestApi(callAdapter: $callAdapter)
@Injectable(as: $baseClass)
abstract class $implClass implements $baseClass {
$factory

  @override
  @GET(${featureClass}ApiPaths.${camelCase(repoName)})
  $result get$repoClass(@Query('q') String? q);

  @override
  @POST(${featureClass}ApiPaths.${camelCase(repoName)})
  $result post$repoClass(@Body() ${repoClass}RequestModel? requestModel);
}
'''
      : '''
$imports

import '${repoName}_data_source_base.dart';

part 'rest_${repoName}_data_source.g.dart';

@RestApi(callAdapter: $callAdapter)
@Injectable(as: $baseClass)
abstract class $implClass implements $baseClass {
$factory
}
''';
}
