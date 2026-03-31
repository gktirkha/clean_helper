import 'dart:io';

import '../shared/write_file.dart';

void generateUtilsFiles() {
  writeFile('lib/core/domain/failures/failure.dart', '''
import 'package:fpdart/fpdart.dart';

class Failure implements Exception {
  Failure({this.message});

  final String? message;

  static Either<Failure, T> leftFromError<T>(Object e) =>
      Left(e is Failure ? e : Failure(message: e.toString()));
}
''');

  writeFile('lib/core/utils/functions/get_current_function_name.dart', '''
String getCurrentFunctionName({int frameIndex = 1}) {
  final stackTrace = StackTrace.current;
  final frames = stackTrace.toString().split('\\n');
  if (frames.length > 2) {
    final currentFunctionName = frames[frameIndex].trim();
    final whitespaceIndex = currentFunctionName.indexOf(' ');
    if (whitespaceIndex != -1) {
      return currentFunctionName.substring(whitespaceIndex + 1).trim();
    }
  }
  return 'Name Not Found';
}
''');

  writeFile('lib/core/utils/functions/safe_cast.dart', '''
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
      return Right(decoder(jsonDecode(data)));
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
''');

  writeFile('lib/core/utils/functions/safe_execute.dart', '''
import 'dart:async';
import 'dart:developer';

import 'package:fpdart/fpdart.dart';

import '../../domain/failures/failure.dart';
import 'get_current_function_name.dart';

FutureOr<Either<Failure, T>> safeExecute<T>(FutureOr<T> exec) async {
  try {
    final res = await exec;
    return Right(res);
  } catch (e) {
    log(e.toString(), name: getCurrentFunctionName());
    return Failure.leftFromError(e);
  }
}
''');

  stdout.writeln('🛠️  Utils files generated');
}
