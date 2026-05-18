String vscodeTasksTemplate() => r'''
{
	"version": "2.0.0",
	"tasks": [
		{
			"type": "flutter",
			"command": "dart",
			"args": [
				"run",
				"build_runner",
				"build"
			],
			"problemMatcher": [
				"$dart-build_runner"
			],
			"group": "build",
			"label": "flutter: dart run build_runner build",
			"detail": ""
		},
		{
			"type": "flutter",
			"command": "dart",
			"args": [
				"run",
				"build_runner",
				"watch"
			],
			"problemMatcher": [
				"$dart-build_runner"
			],
			"group": "build",
			"label": "flutter: dart run build_runner watch",
			"detail": ""
		},
		{
			"type": "flutter",
			"command": "dart",
			"args": [
				"run",
				"build_runner",
				"clean"
			],
			"problemMatcher": [
				"$dart-build_runner"
			],
			"group": "build",
			"label": "flutter: dart run build_runner clean",
			"detail": ""
		},
		{
			"type": "flutter",
			"command": "dart",
			"args": [
				"run",
				"slang"
			],
			"problemMatcher": [],
			"group": "build",
			"label": "flutter: dart run slang (localization)",
			"detail": ""
		},
		{
			"type": "shell",
			"command": "fluttergen",
			"args": [],
			"problemMatcher": [],
			"group": "build",
			"label": "fluttergen",
			"detail": ""
		}
	]
}
''';
