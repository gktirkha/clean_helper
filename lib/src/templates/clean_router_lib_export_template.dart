/// [prefix] leads from the barrel back to `lib/` (see `packageBarrelPrefix`).
String cleanRouterLibExportTemplate([String prefix = '']) =>
    '''
export '${prefix}src/clean_router_base.dart';
export '${prefix}src/clean_router_refresh.dart';
''';
