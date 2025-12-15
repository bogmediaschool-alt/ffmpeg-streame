import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/ai_client.dart';
import '../domain/assistant_message.dart';

final aiClientProvider = Provider<AiClient>((ref) => createAiClient());

class AssistantChatController extends StateNotifier<List<AssistantMessage>> {
  AssistantChatController(this._client) : super(const []);

  final AiClient _client;

  Future<void> send(String message) async {
    final userMessage = AssistantMessage(
      sender: AssistantSender.user,
      content: message,
      timestamp: DateTime.now(),
    );
    state = [...state, userMessage];
    final reply = await _client.sendMessage(state, message);
    state = [...state, reply];
  }
}

final assistantChatProvider =
    StateNotifierProvider<AssistantChatController, List<AssistantMessage>>((ref) {
  return AssistantChatController(ref.read(aiClientProvider));
});
