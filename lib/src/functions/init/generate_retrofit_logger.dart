import '../shared/write_file.dart';
import '../../templates/retrofit_logger_template.dart';

void generateRetrofitLogger() {
  writeFile(
    'lib/core/network/utils/retrofit_logger.dart',
    retrofitLoggerTemplate(),
  );
}
