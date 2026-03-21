import 'dart:io';

// Usage:
//   dart run tools/generate_entity.dart <feature|core> <entity_name> [folder]
//
// Examples:
//   dart run tools/generate_entity.dart home invoice
//   dart run tools/generate_entity.dart home invoice requests
//   dart run tools/generate_entity.dart core error

void addEntity(List<String> args) {
  if (!File('pubspec.yaml').existsSync()) {
    stderr.writeln(
      '❌ pubspec.yaml not found. Run this tool from the Flutter project root.',
    );
    exit(1);
  }

  if (args.length < 2) {
    stderr.writeln(
      '❌ Usage: dart run tools/generate_entity.dart <feature|core> <entity_name> [folder]',
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

  _generateEntity(entityDir, entityName);
  _generateModel(modelDir, entityName, entityToModelImport);

  stdout.writeln('✅ Entity "$entityName" generated in $scope.');
}

void _generateEntity(String dir, String name) {
  final className = _pascalCase(name);
  final path = '$dir/${name}_entity.dart';

  _write(path, '''
abstract class ${className}Entity {}
''');
  stdout.writeln('  📄 $path');
}

void _generateModel(String dir, String name, String entityImport) {
  final className = _pascalCase(name);
  final path = '$dir/${name}_model.dart';

  _write(path, '''
import 'package:freezed_annotation/freezed_annotation.dart';

import '$entityImport';

part '${name}_model.freezed.dart';
part '${name}_model.g.dart';

@freezed
sealed class ${className}Model with _\$${className}Model implements ${className}Entity {
  const factory ${className}Model() = _${className}Model;

  factory ${className}Model.fromJson(Map<String, dynamic> json) =>
      _\$${className}ModelFromJson(json);
}
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
