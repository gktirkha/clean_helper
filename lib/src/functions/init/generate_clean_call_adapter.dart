import '../shared/write_file.dart';
import '../../templates/clean_call_adapter_template.dart';

void generateCleanCallAdapter() {
  writeFile(
    'lib/core/network/utils/clean_call_adapter.dart',
    cleanCallAdapterTemplate(),
  );
}
