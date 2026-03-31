import 'dart:io';

import '../shared/write_file.dart';
import '../../templates/build_yaml_template.dart';
import '../../templates/colors_xml_template.dart';

void generateFlutterGenFiles() {
  writeFile('build.yaml', buildYamlTemplate());
  writeFile('assets/colors/colors.xml', colorsXmlTemplate());
  stdout.writeln('🎨 FlutterGen files generated');
}
