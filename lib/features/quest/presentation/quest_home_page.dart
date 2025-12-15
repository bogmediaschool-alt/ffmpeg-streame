import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/application/auth_controller.dart';
import '../application/quest_controller.dart';

class QuestHomePage extends ConsumerWidget {
  const QuestHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).value;
    final tasks = ref.watch(todayTasksProvider);
    return tasks.when(
      data: (items) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome ${user?.nickname ?? 'Adventurer'}',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Daily Quest', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text('${items.length} tasks · Earn XP to level up'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: items.isEmpty
                          ? null
                          : () => context.go('/quest/task'),
                      child: const Text('Start'),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Could not load tasks: $e'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => ref.refresh(todayTasksProvider),
              child: const Text('Retry'),
            )
          ],
        ),
      ),
    );
  }
}
