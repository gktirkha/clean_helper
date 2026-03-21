import 'dart:io';

import '../shared/run_command.dart';

void installNetworkDependencies() {
  stdout.writeln('📦 Installing network dependencies...');

  final deps = ['dio', 'retrofit', 'json_annotation', 'pretty_dio_logger'];

  final devDeps = ['retrofit_generator', 'json_serializable'];

  runCommand(['dart', 'pub', 'add', ...deps]);
  runCommand(['dart', 'pub', 'add', '--dev', ...devDeps]);

  stdout.writeln('📦 Network dependencies installed');
}
