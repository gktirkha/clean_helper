import 'dart:io';

import '../shared/write_file.dart';

void patchPackagePubspec(String packagePath, String pubspecTail) {
  final file = File('$packagePath/pubspec.yaml');
  final lines = file.readAsLinesSync();

  final noComments = lines.where((l) => !l.trimLeft().startsWith('#')).toList();

  final envStart = noComments.indexWhere((l) => l.startsWith('environment:'));
  var envEnd = envStart + 1;
  while (envEnd < noComments.length) {
    final line = noComments[envEnd];
    if (line.isNotEmpty && !line.startsWith(' ') && !line.startsWith('\t')) {
      break;
    }
    envEnd++;
  }

  final header = noComments.sublist(0, envEnd).join('\n').trimRight();
  overwriteFile('$packagePath/pubspec.yaml', '$header\n\n$pubspecTail');
}
