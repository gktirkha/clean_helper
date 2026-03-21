import 'dart:io';

import '../functions/init/run_dart_format.dart';
import '../functions/repo/generate_data_repo.dart';
import '../functions/repo/generate_domain_repo.dart';
import '../functions/shared/ensure_pubspec.dart';

void addRepo(List<String> args) {
  ensurePubspec();

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

  generateDomainRepo(domainDir, repoName);
  generateDataRepo(dataDir, repoName, domainToDataImport);
  runDartFormat();

  stdout.writeln('✅ Repository "$repoName" generated in $scope.');
}
