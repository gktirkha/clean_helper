String appLoggerTemplate() => '''
import 'package:logger/logger.dart';

import '../../../app/di/di_container.dart';

class AppLogger {
  static Logger get _logger => diContainer();
  static final trace = _logger.t;
  static final debug = _logger.d;
  static final info = _logger.i;
  static final warning = _logger.w;
  static final error = _logger.e;
  static final what = _logger.w;
}
''';
