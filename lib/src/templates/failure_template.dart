String failureTemplate() => '''
import 'package:fpdart/fpdart.dart';

class Failure implements Exception {
  Failure({this.message});

  final String? message;

  static Either<Failure, T> leftFromError<T>(Object e) =>
      Left(e is Failure ? e : Failure(message: e.toString()));
}
''';
