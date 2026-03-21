import 'dart:io';

import '../functions/entity/generate_entity_file.dart';
import '../functions/init/run_dart_format.dart';
import '../functions/repo/generate_api_paths.dart';
import '../functions/repo/generate_data_repo.dart';
import '../functions/repo/generate_data_source_base.dart';
import '../functions/repo/generate_domain_repo.dart';
import '../functions/repo/generate_request_model.dart';
import '../functions/repo/generate_response_model.dart';
import '../functions/repo/generate_rest_data_source.dart';
import '../functions/shared/ensure_pubspec.dart';
import '../functions/shared/read_package_name.dart';

void addRepo(List<String> args) {
  ensurePubspec();

  if (args.length < 2) {
    stderr.writeln('❌ Usage: dart run bin/add_repo.dart <feature> <repo_name>');
    stderr.writeln('   Example: dart run bin/add_repo.dart home invoice');
    exit(1);
  }

  final feature = args[0].toLowerCase();
  final repoName = args[1].toLowerCase();
  final packageName = readPackageName();

  final dataDir = 'lib/features/$feature/data';
  final domainDir = 'lib/features/$feature/domain/repositories';
  final entitiesDir = 'lib/features/$feature/domain/entities';

  for (final dir in [
    '$dataDir/constants',
    '$dataDir/datasources',
    '$dataDir/models/requests',
    '$dataDir/models/response',
    '$dataDir/repositories',
    domainDir,
    entitiesDir,
  ]) {
    Directory(dir).createSync(recursive: true);
  }

  stdout.writeln('🚀 Generating data layer: feature=$feature, repo=$repoName');

  generateEntityFile(entitiesDir, repoName);
  generateDomainRepo(domainDir, repoName);
  generateApiPaths(dataDir, feature, repoName);
  generateDataSourceBase(dataDir, repoName);
  generateRestDataSource(dataDir, feature, repoName, packageName);
  generateRequestModel(dataDir, repoName);
  generateResponseModel(dataDir, repoName);
  generateDataRepo(dataDir, feature, repoName, packageName);

  runDartFormat();

  stdout.writeln();
  stdout.writeln(
    '✅ Data layer for "$repoName" generated in feature "$feature".',
  );
  stdout.writeln();
  stdout.writeln('Next steps:');
  stdout.writeln(
    '  1. Add your endpoint paths to $dataDir/constants/${feature}_api_paths.dart',
  );
  stdout.writeln(
    '  2. Add method signatures to $dataDir/datasources/${repoName}_data_source_base.dart',
  );
  stdout.writeln(
    '  3. Add @GET/@POST methods to $dataDir/datasources/rest_${repoName}_data_source.dart',
  );
  stdout.writeln('  4. Add fields to the request/response models.');
  stdout.writeln(
    '  5. Implement repository methods in $dataDir/repositories/${repoName}_repository_impl.dart',
  );
  stdout.writeln(
    '  6. Run: fvm dart run build_runner build --delete-conflicting-outputs',
  );
}
