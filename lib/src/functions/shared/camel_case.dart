import 'pascal_case.dart';

String camelCase(String input) {
  final pascal = pascalCase(input);
  return pascal[0].toLowerCase() + pascal.substring(1);
}
