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
  bool addSample = false,
}) {
  final result = 'TaskEither<Failure, ${repoClass}ResponseModel>';

  // The call adapter is the app's (lib/core/network/adapters/); Failure
  // comes from the utils package.
  final imports = sortImports([
    "import 'package:dio/dio.dart';",
    if (addSample) "import 'package:fpdart/fpdart.dart';",
    "import 'package:injectable/injectable.dart';",
    "import 'package:retrofit/retrofit.dart';",
    "import '$utilsImport';",
  ]);

  final factory = '''
  @factoryMethod
  factory $implClass(Dio dio, {ParseErrorLogger? errorLogger}) = _$implClass;''';

  return addSample
      ? '''
$imports

${sortImports(["import '../../../../core/network/adapters/app_call_adapter.dart';", "import '../constants/${feature}_api_paths.dart';", "import '../models/requests/${repoName}_request_model.dart';", "import '../models/response/${repoName}_response_model.dart';", "import '${repoName}_data_source_base.dart';"])}

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

import '../../../../core/network/adapters/app_call_adapter.dart';
import '${repoName}_data_source_base.dart';

part 'rest_${repoName}_data_source.g.dart';

@RestApi(callAdapter: $callAdapter)
@Injectable(as: $baseClass)
abstract class $implClass implements $baseClass {
$factory
}
''';
}
