/// `lib/core/network/failures/api_failure.dart`: the [Failure] the app's call
/// adapter returns for API errors.
String apiFailureTemplate(String utilsImport) =>
    '''
import '$utilsImport';

import '../../data/models/error_model.dart';

/// A [Failure] from an API call.
class ApiFailure extends Failure {
  ApiFailure({super.message, this.statusCode, this.error});

  /// HTTP status code, if a response was received.
  final int? statusCode;

  /// Backend's parsed error body, if the response matched its error format.
  final ErrorModel? error;
}
''';
