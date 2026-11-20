/// The theme package's barrel. [base] is the package name without `_theme`;
/// [prefix] leads from the barrel back to `lib/` (see `packageBarrelPrefix`).
String themeLibExportTemplate(String base, String prefix) {
  final exports = [
    'src/adaptive_color.dart',
    'src/theme_manager/theme_resolver.dart',
    'src/${base}_material_theme.dart',
    'src/${base}_theme.dart',
    'src/${base}_theme_data.dart',
    'src/${base}_theme_scope.dart',
  ]..sort();
  return '${exports.map((e) => "export '$prefix$e';").join('\n')}\n';
}
