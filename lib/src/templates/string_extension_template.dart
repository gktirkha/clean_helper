String stringExtensionTemplate() => '''
import 'generated/locales.g.dart';

extension StringLocaleExtension on String {
  String get tr => locales.\$meta.getTranslation(this);
}
''';
