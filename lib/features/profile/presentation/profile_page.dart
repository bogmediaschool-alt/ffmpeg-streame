import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/application/auth_controller.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: authState.when(
        data: (user) => user == null
            ? const Center(child: Text('Not signed in'))
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(child: Text(user.nickname.characters.first)),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.nickname, style: Theme.of(context).textTheme.titleLarge),
                            Text('Grade ${user.grade} • Level ${user.level}')
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text('XP: ${user.xp}'),
                    Text('Streak: ${user.streak}'),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
                      child: const Text('Sign out'),
                    )
                  ],
                ),
              ),
        error: (e, _) => Center(child: Text('Error: $e')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
