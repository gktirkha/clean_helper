import 'dart:io';

import '../shared/write_file.dart';

void sortPubspecDeps([String path = 'pubspec.yaml']) {
  String sortSection(String content, String sectionName) {
    final headerMatch = RegExp(
      '^$sectionName:\$',
      multiLine: true,
    ).firstMatch(content);
    if (headerMatch == null) return content;

    final bodyStart = headerMatch.end;
    final afterBody = content.substring(bodyStart);
    final nextTopLevel = RegExp(r'^\S', multiLine: true).firstMatch(afterBody);
    final bodyEnd = nextTopLevel != null
        ? bodyStart + nextTopLevel.start
        : content.length;

    final body = content.substring(bodyStart, bodyEnd);

    final entries = <(String, List<String>)>[];
    List<String>? currentLines;
    String? currentKey;

    for (final line in body.split('\n')) {
      if (line.isEmpty) continue;
      if (RegExp(r'^  \S').hasMatch(line)) {
        if (currentKey != null && currentLines != null) {
          entries.add((currentKey, currentLines));
        }
        currentKey = line.trim().split(':').first;
        currentLines = [line];
      } else if (currentLines != null && line.startsWith('    ')) {
        currentLines.add(line);
      }
    }
    if (currentKey != null && currentLines != null) {
      entries.add((currentKey, currentLines));
    }

    entries.sort((a, b) => a.$1.toLowerCase().compareTo(b.$1.toLowerCase()));

    final trailing = RegExp(r'\n+$').firstMatch(body)?.group(0) ?? '\n';
    final sortedBody =
        '\n${entries.map((e) => e.$2.join('\n')).join('\n')}$trailing';

    return content.substring(0, bodyStart) +
        sortedBody +
        content.substring(bodyEnd);
  }

  var content = File(path).readAsStringSync();
  content = sortSection(content, 'dependencies');
  content = sortSection(content, 'dev_dependencies');
  overwriteFile(path, content);
  stdout.writeln('📋 $path dependencies sorted');
}
