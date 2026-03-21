import 'dart:io';

import '../shared/write_file.dart';

void generateFlutterGenFiles() {
  writeFile('build.yaml', '''
targets:
  \$default:
    builders:
      flutter_gen_runner:
        options:
          output: lib/core/generated/flutter_gen
          integrations:
            flutter_svg: true

          assets:
            outputs:
              directory_path_enabled: true

          colors:
            inputs:
              - assets/colors/colors.xml
''');

  writeFile('assets/colors/colors.xml', '''
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="black" type="material material-accent">#000000</color>
</resources>
''');

  stdout.writeln('🎨 FlutterGen files generated');
}
