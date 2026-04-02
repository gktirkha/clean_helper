String getCurrentFunctionNameTemplate() => '''
import 'pretty_logger.dart';

String getCurrentFunctionName({int frameIndex = 1, bool printPath = false}) {
  final nameNotFound = 'Name Not Found';
  try {
    final stackTrace = StackTrace.current;
    final frames = stackTrace.toString().split('\\n');
    if (frames.length > 2) {
      final currentFunctionName = frames[frameIndex].trim();
      final whitespaceIndex = currentFunctionName.indexOf(' ');
      if (whitespaceIndex != -1) {
        final full = currentFunctionName.substring(whitespaceIndex + 1).trim();
        if (printPath) return full;
        final parenIndex = full.indexOf(' ');
        return parenIndex != -1 ? full.substring(0, parenIndex) : full;
      }
    }
  } catch (e, s) {
    PrettyLogger.error(
      getCurrentFunctionName(),
      stackTrace: s,
      error: e,
      time: DateTime.now(),
    );
    return nameNotFound;
  }
  return nameNotFound;
}
''';
