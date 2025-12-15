import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/application/auth_controller.dart';
import '../application/quest_controller.dart';

class QuestCompletionPage extends ConsumerWidget {
  const QuestCompletionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(todayTasksProvider).value ?? [];
    final points = tasks.fold<int>(0, (sum, task) => sum + task.points);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events, size: 72, color: Colors.amber),
              const SizedBox(height: 12),
              Text('Quest complete!', style: Theme.of(context).textTheme.headlineMedium),
              Text('You earned $points XP'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await ref.read(questSubmissionProvider.notifier).submit(
                        score: points,
                        totalPoints: points,
                      );
                  final user = ref.read(authControllerProvider).value;
                  if (user != null) {
                    final updated = user.copyWith(
                      xp: user.xp + points,
                      level: (user.xp + points) ~/ 100 + 1,
                    );
                    await ref.read(authControllerProvider.notifier).updateProfile(updated);
                  }
                  ref.read(questProgressProvider.notifier).reset();
                  if (context.mounted) {
                    context.go('/');
                  }
                },
                child: const Text('Back to home'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
