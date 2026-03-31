import 'dart:io';

import '../shared/write_file.dart';
import '../../templates/auth_interceptor_template.dart';

void generateAuthInterceptor() {
  const path = 'lib/core/network/interceptors/auth_interceptor.dart';

  writeFile(path, authInterceptorTemplate());
  stdout.writeln('  📄 $path');
}
