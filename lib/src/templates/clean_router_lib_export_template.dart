/// [prefix] leads from the barrel back to `lib/` (see `packageBarrelPrefix`);
/// [name] is the router package name, which names its source files.
String cleanRouterLibExportTemplate(String name, [String prefix = '']) =>
    '''
export '${prefix}src/${name}_base.dart';
export '${prefix}src/${name}_refresh.dart';
''';
