String appGoRouterRedirectTemplate() => '''
// GENERATED CODE — DO NOT EDIT MANUALLY
// Managed by clean_helpers. Changes will be lost on re-generation.

part of 'app_go_router.dart';

FutureOr<String?> _handleRedirect(
  BuildContext context,
  GoRouterState state,
  List<RouterBase> routers,
) {
  for (final router in routers) {
    final result = router.redirect(context, state);
    if (result != null) return result;
  }
  return null;
}
''';
