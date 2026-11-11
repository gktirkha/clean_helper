/// [generatedFile] is the slang output relative to the package's `lib/`,
/// e.g. `src/generated/locales.g.dart`. [prefix] leads from the barrel back
/// to `lib/` (see `packageBarrelPrefix`).
String localizationLibExportTemplate(String generatedFile, String prefix) =>
    '''
export '$prefix$generatedFile';
export '${prefix}src/string_extension.dart';
''';
