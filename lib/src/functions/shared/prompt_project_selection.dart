import 'dart:io';

/// Displays an interactive numbered menu and returns the chosen app path.
///
/// [title] overrides the default heading — useful when showing a filtered
/// subset of apps (e.g. multiple apps sharing the same name).
String promptProjectSelection(List<String> apps, {String? title}) {
  stdout.writeln(
    title ??
        '📦 Multiple mono-repo projects detected. Please select a project:',
  );
  for (var i = 0; i < apps.length; i++) {
    final label = apps[i].split('/').last;
    stdout.writeln('  ${i + 1}. $label  (${apps[i]})');
  }

  while (true) {
    stdout.write('Enter number (1–${apps.length}): ');
    final input = stdin.readLineSync()?.trim();
    final index = int.tryParse(input ?? '');
    if (index != null && index >= 1 && index <= apps.length) {
      return apps[index - 1];
    }
    stdout.writeln(
      'Invalid selection. Please enter a number between 1 and ${apps.length}.',
    );
  }
}
