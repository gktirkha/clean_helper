import 'dart:io';

// Usage:
//   dart run tools/generate_repo.dart <feature|core> <repo_name>
//
// Examples:
//   dart run tools/generate_repo.dart home invoice
//   dart run tools/generate_repo.dart core user

void addRepo(List<String> args) {
  if (!File('pubspec.yaml').existsSync()) {
    stderr.writeln(
      '❌ pubspec.yaml not found. Run this tool from the Flutter project root.',
    );
    exit(1);
  }

  if (args.length < 2) {
    stderr.writeln(
      '❌ Usage: dart run tools/generate_repo.dart <feature|core> <repo_name>',
    );
    exit(1);
  }

  final scope = args[0].toLowerCase();
  final repoName = args[1].toLowerCase();

  final String domainDir;
  final String dataDir;
  final String domainToDataImport;

  if (scope == 'core') {
    domainDir = 'lib/core/domain/repositories';
    dataDir = 'lib/core/data/repositories';
    domainToDataImport =
        '../../domain/repositories/${repoName}_repository.dart';
  } else {
    domainDir = 'lib/features/$scope/domain/repositories';
    dataDir = 'lib/features/$scope/data/repositories';
    domainToDataImport =
        '../../domain/repositories/${repoName}_repository.dart';
  }

  Directory(domainDir).createSync(recursive: true);
  Directory(dataDir).createSync(recursive: true);

  _generateDomainRepo(domainDir, repoName);
  _generateDataRepo(dataDir, repoName, domainToDataImport);

  stdout.writeln('✅ Repository "$repoName" generated in $scope.');
}

void _generateDomainRepo(String dir, String name) {
  final className = _pascalCase(name);
  final path = '$dir/${name}_repository.dart';

  _write(path, '''
abstract interface class ${className}Repository {}
''');
  stdout.writeln('  📄 $path');
}

void _generateDataRepo(String dir, String name, String domainImport) {
  final className = _pascalCase(name);
  final path = '$dir/${name}_repository_impl.dart';

  _write(path, '''
import 'package:injectable/injectable.dart';

import '$domainImport';

@LazySingleton(as: ${className}Repository)
class ${className}RepositoryImpl implements ${className}Repository {}
''');
  stdout.writeln('  📄 $path');
}

void _write(String path, String content) {
  final file = File(path);
  if (file.existsSync()) {
    stdout.writeln('  ⏭  Skipped (exists): $path');
    return;
  }
  file.writeAsStringSync(content);
}

String _pascalCase(String input) =>
    input.split('_').map((e) => e[0].toUpperCase() + e.substring(1)).join();
