String stringExtensionTemplate() => '''
import '../../../generated/locales/locales.g.dart';

extension StringExtension on String {
  String get tr => locales.\$meta.getTranslation(this);
}
''';
