import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/leaderboard_controller.dart';

class LeaderboardPage extends ConsumerWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final top = ref.watch(leaderboardProvider);
    final rank = ref.watch(yourRankProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: top.when(
        data: (users) => Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: users.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    leading: CircleAvatar(child: Text('#${index + 1}')),
                    title: Text(user.nickname),
                    subtitle: Text('Grade ${user.grade}'),
                    trailing: Text('${user.xp} XP'),
                  );
                },
              ),
            ),
            const Divider(height: 1),
            rank.when(
              data: (value) => Padding(
                padding: const EdgeInsets.all(16),
                child: value == null
                    ? const Text('You are not in top 10 yet. Keep going!')
                    : Text('Your rank: #$value'),
              ),
              loading: () => const Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
              error: (e, _) => Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Could not load your rank: $e'),
              ),
            )
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
