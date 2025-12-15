enum AssistantSender { user, assistant, system }

class AssistantMessage {
  final AssistantSender sender;
  final String content;
  final DateTime timestamp;

  const AssistantMessage({
    required this.sender,
    required this.content,
    required this.timestamp,
  });
}
