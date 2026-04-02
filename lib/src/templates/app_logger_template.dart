String appLoggerTemplate() => '''
import 'package:logger/logger.dart';

import '../../../app/di/di_container.dart';

class AppLogger {
  static Logger get _logger => diContainer();
  static final trace = _logger.t;
  static final debug = _logger.t;
  static final info = _logger.t;
  static final warning = _logger.t;
  static final error = _logger.t;
  static final what = _logger.w;
}
''';
