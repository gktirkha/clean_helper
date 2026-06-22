String appLoggerTemplate() => '''
import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger();
  static final trace = _logger.t;
  static final debug = _logger.d;
  static final info = _logger.i;
  static final warning = _logger.w;
  static final error = _logger.e;
  static final what = _logger.w;
}
''';
