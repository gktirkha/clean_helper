import 'dart:io';

void main(List<String> args) {
  Process.run("clean_helpers", ['install-completion-files']);
}
