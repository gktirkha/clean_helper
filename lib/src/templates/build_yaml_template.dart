String buildYamlTemplate() => r'''
targets:
  $default:
    builders:
      flutter_gen_runner:
        options:
          output: lib/generated/flutter_gen
          integrations:
            flutter_svg: true

          assets:
            outputs:
              directory_path_enabled: true

          colors:
            inputs:
              - assets/colors/colors.xml
''';
