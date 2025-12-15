import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../assistant_chat/data/ai_client.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final useMock = dotenv.env['USE_AI_MOCK'] == 'true';
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('AI mode: ${useMock ? 'Mock responses' : 'Cloud Function'}'),
            const SizedBox(height: 8),
            const Text('Configure AI_FUNCTION_URL & USE_AI_MOCK in .env'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.refresh(aiClientProvider),
              child: const Text('Reload AI client'),
            )
          ],
        ),
      ),
    );
  }
}
