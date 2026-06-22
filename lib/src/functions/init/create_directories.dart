import 'dart:io';

void createDirectories() {
  final dirs = [
    // core
    'lib/app/router',
    'lib/app/navigation',
    'lib/app/di',
    'lib/core/di',
    'lib/core/domain/use_cases',
    // network
    'lib/core/network/constants',
    'lib/core/network/di',
    'lib/core/network/interceptors',
    'lib/core/network/models',
    'lib/core/data/models',
    'lib/core/services',
    // assets
    'assets/colors',
    // generated
    'lib/generated/flutter_gen',
    // home feature
    'lib/features/home/data/constants',
    'lib/features/home/data/datasources',
    'lib/features/home/data/models/requests',
    'lib/features/home/data/models/response',
    'lib/features/home/data/repositories',
    'lib/features/home/domain/entities',
    'lib/features/home/domain/repositories',
    'lib/features/home/domain/use_cases',
    'lib/features/home/presentation/bloc/home',
    'lib/features/home/presentation/pages',
    'lib/features/home/presentation/widgets',
    'lib/features/home/router',
  ];

  for (final dir in dirs) {
    Directory(dir).createSync(recursive: true);
  }
  stdout.writeln('📁 Directories created');
}
