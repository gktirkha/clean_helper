String gitignoreTemplate() => '''
# Clean-Helper Added
*.g.dart
*.gen.dart
*.freezed.dart
*.config.dart
*.module.dart
tools/config/android_build_config.json
**/pubspec.lock
**/build/
**/generated/**
''';

const gitignoreMarker = '# Clean-Helper Added';
