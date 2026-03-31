String restDataSourceTemplate(
  String featureClass,
  String repoClass,
  String baseClass,
  String implClass,
  String feature,
  String repoName,
) =>
    '''
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../constants/${feature}_api_paths.dart';
import '../models/requests/${repoName}_request_model.dart';
import '../models/response/${repoName}_response_model.dart';
import '${repoName}_data_source_base.dart';

part 'rest_${repoName}_data_source.g.dart';

@RestApi()
@Injectable(as: $baseClass)
abstract class $implClass implements $baseClass {
  @factoryMethod
  factory $implClass(Dio dio, {ParseErrorLogger? errorLogger}) = _$implClass;

  @override
  @GET(${featureClass}ApiPaths.$repoName)
  Future<${repoClass}ResponseModel> get$repoClass();

  @override
  @GET(${featureClass}ApiPaths.$repoName)
  Future<${repoClass}ResponseModel> post$repoClass(@Body() ${repoClass}RequestModel? requestModel);
}
''';
