import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../domain/assistant_message.dart';

abstract class AiClient {
  Future<AssistantMessage> sendMessage(List<AssistantMessage> history, String prompt);
}

class MockAiClient implements AiClient {
  @override
  Future<AssistantMessage> sendMessage(List<AssistantMessage> history, String prompt) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return AssistantMessage(
      sender: AssistantSender.assistant,
      content:
          'I\'m your friendly study buddy! You asked: "$prompt". Let\'s explore it safely together.',
      timestamp: DateTime.now(),
    );
  }
}

class CloudFunctionAiClient implements AiClient {
  CloudFunctionAiClient(this._dio, {required this.baseUrl});

  final Dio _dio;
  final String baseUrl;
  static const systemPrompt =
      'You are Daily Quest tutor for kids. Be kind, safe, avoid 18+ or dangerous instructions. Decline unsafe requests and suggest a safe alternative. Never ask for personal data.';

  @override
  Future<AssistantMessage> sendMessage(List<AssistantMessage> history, String prompt) async {
    final messagesPayload = history
        .map((m) => {
              'role': m.sender == AssistantSender.assistant
                  ? 'assistant'
                  : m.sender == AssistantSender.system
                      ? 'system'
                      : 'user',
              'content': m.content,
            })
        .toList();
    messagesPayload.insert(0, {'role': 'system', 'content': systemPrompt});
    final response = await _dio.post(
      baseUrl,
      data: {
        'messages': messagesPayload,
        'prompt': prompt,
      },
    );
    final content = response.data['reply'] as String? ?? 'Let\'s keep learning!';
    return AssistantMessage(
      sender: AssistantSender.assistant,
      content: content,
      timestamp: DateTime.now(),
    );
  }
}

AiClient createAiClient() {
  final useMock = dotenv.env['USE_AI_MOCK'] == 'true';
  if (useMock) return MockAiClient();
  final url = dotenv.env['AI_FUNCTION_URL'] ?? '';
  return CloudFunctionAiClient(Dio(), baseUrl: url);
}
