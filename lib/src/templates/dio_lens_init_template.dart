/// `DioLens.init` call, indented by [indent], inserted after the
/// `Bloc.observer` line of `InitService.init` (or `bootstrap()` in projects
/// initialised before 1.5.0).
String dioLensInitTemplate(String indent) =>
    '''
${indent}DioLens.init(
$indent  navigatorKey: diContainer(),
$indent  settings: const DioLensSettings(themeMode: .system),
$indent);
''';
