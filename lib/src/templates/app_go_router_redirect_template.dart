/// [routerPrefix] is the router package's class prefix (`<RouterPascal>`).
String appGoRouterRedirectTemplate(String appName, String routerPrefix) =>
    '''
// GENERATED CODE — DO NOT EDIT MANUALLY
// Managed by clean_helper. Changes will be lost on re-generation.

part of '${appName}_router.dart';

FutureOr<String?> _handleRedirect(
  BuildContext context,
  GoRouterState state,
  List<${routerPrefix}Base> routers,
) {
  for (final router in routers) {
    final result = router.redirect(context, state);
    if (result != null) return result;
  }
  return null;
}
''';
