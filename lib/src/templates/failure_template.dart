/// `lib/src/failure.dart` in the utils package. `Failure.fromError` keeps a
/// `Failure` as-is and wraps anything else.
String failureTemplate() => r'''
import 'package:fpdart/fpdart.dart';

class Failure implements Exception {
  factory fromError(Object e) =>
      e is Failure ? e : Failure(message: e.toString());

  Failure({this.message});

  final String? message;

  static Either<Failure, T> leftFromError<T>(Object e) => Left(.fromError(e));
}
''';
