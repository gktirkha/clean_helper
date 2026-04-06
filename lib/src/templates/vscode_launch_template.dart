String vscodeLaunchTemplate(String appName) => '''
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "$appName",
            "request": "launch",
            "type": "dart"
        },
        {
            "name": "$appName (profile mode)",
            "request": "launch",
            "type": "dart",
            "flutterMode": "profile"
        },
        {
            "name": "$appName (release mode)",
            "request": "launch",
            "type": "dart",
            "flutterMode": "release"
        }
    ]
}
''';
