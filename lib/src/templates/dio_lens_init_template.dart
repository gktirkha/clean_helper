/// `DioLens.init` call, indented by [indent], inserted after the
/// `Bloc.observer` line of `InitService.init`.
String dioLensInitTemplate(String indent) =>
    '''
${indent}DioLens.init(
$indent  navigatorKey: diContainer(),
$indent  settings: const DioLensSettings(themeMode: .system),
$indent);
''';
