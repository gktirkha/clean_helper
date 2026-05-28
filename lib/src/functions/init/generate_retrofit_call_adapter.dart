import '../shared/write_file.dart';
import '../../templates/retrofit_call_adapter_template.dart';

void generateRetrofitCallAdapter() {
  writeFile(
    'lib/core/network/utils/retrofit_call_adapter.dart',
    retrofitCallAdapterTemplate(),
  );
}
