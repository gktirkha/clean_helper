import '../functions/agent_context/agent_command_docs.dart';

/// `.agents/commands/<name>.md`: one clean-helper command for AI agents.
String agentContextCommandTemplate(AgentCommandDoc doc) {
  final details = doc.details.isEmpty ? '' : '\n${doc.details}\n';
  return '''
# `clean-helper ${doc.name}`

${doc.summary} ${doc.whenToUse}

```bash
${doc.usage}
```
$details''';
}
