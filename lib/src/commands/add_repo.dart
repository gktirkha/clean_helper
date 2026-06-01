import 'dart:io';

import '../functions/entity/generate_entity_file.dart';
import '../functions/init/run_build_runner.dart';
import '../functions/init/run_dart_format.dart';
import '../functions/repo/generate_api_paths.dart';
import '../functions/repo/generate_data_repo.dart';
import '../functions/repo/generate_data_source_base.dart';
import '../functions/repo/generate_domain_repo.dart';
import '../functions/repo/generate_request_model.dart';
import '../functions/repo/generate_response_model.dart';
import '../functions/repo/generate_rest_data_source.dart';
import '../functions/repo/generate_use_cases.dart';
import '../functions/shared/ensure_pubspec.dart';

void addRepo(
  List<String> args, {
  bool runBuildRunnerAfter = true,
  bool noRest = false,
  bool addSample = false,
}) {
  ensurePubspec();

  if (args.length < 2) {
    stderr.writeln(
      '❌ Usage: dart run bin/add_repo.dart <feature> <repo_name> [--no-rest] [--add-sample]',
    );
    stderr.writeln('   Example: dart run bin/add_repo.dart home invoice');
    exit(1);
  }

  final feature = args[0].toLowerCase();
  final repoName = args[1].toLowerCase();

  final dataDir = 'lib/features/$feature/data';
  final domainDir = 'lib/features/$feature/domain/repositories';
  final entitiesDir = 'lib/features/$feature/domain/entities';

  final hasNetworkModule = File(
    'lib/core/network/di/network_module.dart',
  ).existsSync();

  final generateRest = !noRest && hasNetworkModule;

  stdout.writeln('🚀 Generating data layer: feature=$feature, repo=$repoName');

  generateEntityFile(entitiesDir, repoName);
  generateDomainRepo(domainDir, repoName, addSample: addSample);
  generateDataSourceBase(dataDir, repoName, addSample: addSample);

  if (addSample) {
    generateUseCases(feature, repoName);
    generateRequestModel(dataDir, repoName);
    generateResponseModel(dataDir, repoName);
  } else {
    stdout.writeln(
      '  ⏭  Skipping request/response models (--add-sample not set).',
    );
  }

  generateDataRepo(dataDir, repoName, addSample: addSample);

  if (generateRest) {
    generateApiPaths(dataDir, feature, repoName);
    generateRestDataSource(dataDir, feature, repoName, addSample: addSample);
  } else if (noRest) {
    stdout.writeln('  ⏭  Skipping REST datasource and API paths (--no-rest).');
  } else {
    stdout.writeln(
      '  ⚠️  Network module not found — skipping REST datasource and API paths.',
    );
  }

  runDartFormat();
  if (runBuildRunnerAfter) runBuildRunner();

  stdout.writeln();
  stdout.writeln(
    '✅ Data layer for "$repoName" generated in feature "$feature".',
  );
  stdout.writeln();
  stdout.writeln('Next steps:');
  stdout.writeln(
    '  1. Add method signatures to $dataDir/datasources/${repoName}_data_source_base.dart',
  );
  if (addSample) {
    if (generateRest) {
      stdout.writeln(
        '  2. Add your endpoint paths to $dataDir/constants/${feature}_api_paths.dart',
      );
      stdout.writeln(
        '  3. Add @GET/@POST methods to $dataDir/datasources/rest_${repoName}_data_source.dart',
      );
      stdout.writeln('  4. Add fields to the request/response models.');
      stdout.writeln(
        '  5. Implement repository methods in $dataDir/repositories/${repoName}_repository_impl.dart',
      );
    } else {
      stdout.writeln('  2. Add fields to the request/response models.');
      stdout.writeln(
        '  3. Implement repository methods in $dataDir/repositories/${repoName}_repository_impl.dart',
      );
    }
  } else {
    if (generateRest) {
      stdout.writeln(
        '  2. Add your endpoint paths to $dataDir/constants/${feature}_api_paths.dart',
      );
      stdout.writeln(
        '  3. Add @GET/@POST methods and request/response models to $dataDir/datasources/rest_${repoName}_data_source.dart',
      );
      stdout.writeln(
        '  4. Implement repository methods in $dataDir/repositories/${repoName}_repository_impl.dart',
      );
    } else {
      stdout.writeln(
        '  2. Implement repository methods in $dataDir/repositories/${repoName}_repository_impl.dart',
      );
    }
  }
}
