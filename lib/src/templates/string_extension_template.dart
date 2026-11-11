/// Written to `lib/src/string_extension.dart`. [generatedFile] is the slang
/// output relative to the package's `lib/`; [translateVar] is slang's
/// `translate_var`.
String stringExtensionTemplate(String generatedFile, String translateVar) {
  final import = generatedFile.startsWith('src/')
      ? generatedFile.substring('src/'.length)
      : '../$generatedFile';
  return '''
import '$import';

extension StringLocaleExtension on String {
  String get tr => $translateVar.\$meta.getTranslation(this);
}
''';
}
