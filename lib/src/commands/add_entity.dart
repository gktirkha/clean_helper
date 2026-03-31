import 'dart:io';

import '../functions/entity/generate_entity_file.dart';
import '../functions/entity/generate_model_file.dart';
import '../functions/init/run_build_runner.dart';
import '../functions/init/run_dart_format.dart';
import '../functions/shared/ensure_pubspec.dart';

void addEntity(List<String> args, {bool runBuildRunnerAfter = true}) {
  ensurePubspec();

  if (args.length < 2) {
    stderr.writeln(
      '❌ Usage: clean-helper add_entity <feature|core> <entity_name> [folder]',
    );
    exit(1);
  }

  final scope = args[0].toLowerCase();
  final entityName = args[1].toLowerCase();
  final folder = args.length >= 3 ? args[2].toLowerCase() : null;

  final String entityDir;
  final String baseModelDir;

  if (scope == 'core') {
    entityDir = 'lib/core/domain/entities';
    baseModelDir = 'lib/core/data/models';
  } else {
    entityDir = 'lib/features/$scope/domain/entities';
    baseModelDir = 'lib/features/$scope/data/models';
  }

  final modelDir = folder != null ? '$baseModelDir/$folder' : baseModelDir;
  final entityToModelImport = folder != null
      ? '../../../domain/entities/${entityName}_entity.dart'
      : '../../domain/entities/${entityName}_entity.dart';

  Directory(entityDir).createSync(recursive: true);
  Directory(modelDir).createSync(recursive: true);

  generateEntityFile(entityDir, entityName);
  generateModelFile(modelDir, entityName, entityToModelImport);
  runDartFormat();
  if (runBuildRunnerAfter) runBuildRunner();

  stdout.writeln('✅ Entity "$entityName" generated in $scope.');
}
