/// Connection details for the AI assistant widget's n8n backend.
///
/// The n8n side is expected to expose a single webhook that:
/// - accepts POST { "message": string, "user_id": string? }
/// - returns { "reply": string }
///
/// [webhookUrl] stays empty until that n8n workflow (webhook trigger -> LLM
/// node -> respond) exists and its production webhook URL is known — see
/// project_ai_everywhere.md in memory for the full plan. Until then,
/// AssistantChatScreen shows a "being set up" state instead of calling out
/// to nothing.
class AssistantConfig {
  AssistantConfig._();

  static const String webhookUrl = '';

  static bool get isConfigured => webhookUrl.isNotEmpty;
}
