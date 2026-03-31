String safeCastTemplate() => '''
import 'dart:convert';
import 'dart:developer';

import 'package:fpdart/fpdart.dart';

import '../../../generated/locales/locales.g.dart';
import '../../domain/entities/error_entity.dart';
import '../../domain/failures/failure.dart';
import 'get_current_function_name.dart';

typedef JsonDecodeFactory<T> = T Function(Map<String, dynamic> data);

Either<Failure, T> safeCast<T>(dynamic data, JsonDecodeFactory<T> decoder) {
  try {
    if (data == null) throw Failure(message: 'Data Is Null');
    if (data is ErrorEntity) {
      return Left(
        Failure(
          message:
              data.errors.firstOrNull ?? locales.general.somethingWentWrong,
        ),
      );
    }
    if (data is T) {
      return Right(data);
    }
    if (data is String) {
      return safeCast(jsonDecode(data), decoder);
    }
    if (data is Map<String, dynamic>) {
      return Right(decoder(data));
    }
    throw Failure(message: 'Unable To Cast');
  } catch (e) {
    log(e.toString(), name: getCurrentFunctionName());
    if (e is Failure) return Left(e);
    return Left(Failure(message: e.toString()));
  }
}
''';
