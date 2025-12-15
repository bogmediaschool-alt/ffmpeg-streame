import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/application/auth_controller.dart';
import '../../auth/domain/app_user.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _nicknameController = TextEditingController();
  int _grade = 5;
  String _avatarId = 'avatar_1';

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Set up your hero')),
      body: authState.when(
        data: (user) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Pick your grade'),
              Slider(
                value: _grade.toDouble(),
                min: 5,
                max: 11,
                divisions: 6,
                label: '$_grade',
                onChanged: (value) => setState(() => _grade = value.round()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _nicknameController,
                decoration: const InputDecoration(labelText: 'Nickname'),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                children: List.generate(4, (index) {
                  final id = 'avatar_${index + 1}';
                  return ChoiceChip(
                    label: Text(id),
                    selected: _avatarId == id,
                    onSelected: (_) => setState(() => _avatarId = id),
                  );
                }),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final currentUser = user ?? AppUser.initial('local');
                    final updated = currentUser.copyWith(
                      nickname: _nicknameController.text.isEmpty
                          ? currentUser.nickname
                          : _nicknameController.text,
                      grade: _grade,
                      avatarId: _avatarId,
                    );
                    await ref.read(authControllerProvider.notifier).updateProfile(updated);
                    if (mounted) context.go('/');
                  },
                  child: const Text('Continue'),
                ),
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
