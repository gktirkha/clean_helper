import 'dart:io';

/// Whether the local utils package still contains `RetrofitCallAdapter` and
/// `RetrofitLogger`, as it did for projects initialised before 1.4.4. Newer
/// projects keep them in `lib/core/network/utils/`.
bool utilsHasRetrofitHelpers(String utilsPackageName) => File(
  'packages/$utilsPackageName/lib/src/network/retrofit_call_adapter.dart',
).existsSync();
