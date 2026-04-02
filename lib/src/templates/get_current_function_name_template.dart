String getCurrentFunctionNameTemplate() => '''
import 'app_logger.dart';

String getCurrentFunctionName({int frameIndex = 2, bool includePath = false}) {
  final nameNotFound = 'Name Not Found';
  try {
    final stackTrace = StackTrace.current;
    final frames = stackTrace.toString().split('\n');
    if (frames.length >= frameIndex) {
      final raw = frames[frameIndex].trim();
      final frameContent = raw.replaceFirst(RegExp(r'^#\\d+\\s+'), '').trim();
      if (frameContent.isEmpty) return nameNotFound;
      final parts = frameContent.split(RegExp(r'\\s+'));
      if (parts.isEmpty) return nameNotFound;
      final functionName = parts.last;
      if (includePath && parts.length >= 2) {
        final filePath = parts[0];
        final lineCol = parts[1];
        return '\$functionName(\$filePath:\$lineCol)';
      }
      return functionName;
    }
  } catch (e, s) {
    AppLogger.error(
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
