import 'dart:io';

Never abort(String message) {
  stderr.writeln('❌ $message');
  exit(1);
}
