String safeCastTemplate() => '''
import 'dart:convert';

import 'package:fpdart/fpdart.dart';

import '../app_logger.dart';
import '../failure.dart';
import '../type_definitions.dart';

Either<Failure, T> safeCast<T>(dynamic data, JsonDecodeFactory<T> decoder) {
  try {
    if (data == null) throw Failure(message: 'Data Is Null');
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
  } catch (e, s) {
    AppLogger.error(
      'Error in safe cast',
      error: e,
      stackTrace: s,
      time: DateTime.now(),
    );
    if (e is Failure) return Left(e);
    return Left(Failure(message: e.toString()));
  }
}
''';
