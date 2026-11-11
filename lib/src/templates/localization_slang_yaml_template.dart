/// `slang.yaml` for the localization package, one `key: value` line per
/// setting (see `resolveSlangSettings`).
String localizationSlangYamlTemplate(Map<String, String> settings) =>
    '${settings.entries.map((e) => '${e.key}: ${e.value}').join('\n')}\n';
