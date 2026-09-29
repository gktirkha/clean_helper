import 'dart:io';

import '../shared/pascal_case.dart';
import '../shared/write_file.dart';
import '../../templates/domain_repo_template.dart';

void generateDomainRepo(
  String dir,
  String name,
  String utilsImport, {
  bool addSample = false,
  bool taskEither = true,
}) {
  final className = pascalCase(name);
  final path = '$dir/${name}_repository.dart';

  writeFile(
    path,
    domainRepoTemplate(
      className,
      name,
      utilsImport,
      addSample: addSample,
      taskEither: taskEither,
    ),
  );
  stdout.writeln('  📄 $path');
}
