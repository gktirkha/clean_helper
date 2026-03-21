String analysisOptionsTemplate() => '''
include: package:flutter_lints/flutter.yaml
analyzer:
  errors:
    constant_identifier_names: ignore
    invalid_annotation_target: ignore
    unnecessary_constructor_name: ignore

linter:
  rules:
    - avoid_redundant_argument_values
    - exhaustive_cases
    - sort_constructors_first
    - prefer_relative_imports
    - require_trailing_commas
    - sort_pub_dependencies
    - prefer_single_quotes
    - prefer_const_constructors
''';
