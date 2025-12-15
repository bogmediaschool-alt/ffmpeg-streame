import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../application/quest_controller.dart';

class QuestTaskPage extends ConsumerStatefulWidget {
  const QuestTaskPage({super.key});

  @override
  ConsumerState<QuestTaskPage> createState() => _QuestTaskPageState();
}

class _QuestTaskPageState extends ConsumerState<QuestTaskPage> {
  int _selected = -1;

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(todayTasksProvider);
    final index = ref.watch(questProgressProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Daily quest')),
      body: tasksAsync.when(
        data: (tasks) {
          if (tasks.isEmpty) {
            return const Center(child: Text('No tasks available today.'));
          }
          final task = tasks[index];
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(value: (index + 1) / tasks.length),
                const SizedBox(height: 16),
                Text(task.question, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                ...List.generate(task.options.length, (i) => _OptionTile(
                      title: task.options[i],
                      selected: _selected == i,
                      onTap: () => setState(() => _selected = i),
                    )),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _selected == -1
                        ? null
                        : () {
                            final nextIndex = index + 1;
                            final isCorrect = _selected == task.correctIndex;
                            if (isCorrect) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Correct! +XP')),
                              );
                            }
                            if (nextIndex >= tasks.length) {
                              context.go('/quest/completed');
                            } else {
                              ref.read(questProgressProvider.notifier).next();
                              setState(() => _selected = -1);
                            }
                          },
                    child: Text(index == tasks.length - 1 ? 'Finish' : 'Next'),
                  ),
                )
              ],
            ),
          );
        },
        error: (e, _) => Center(child: Text('Error: $e')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({required this.title, required this.selected, required this.onTap});

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: selected ? Theme.of(context).colorScheme.primaryContainer : null,
      child: ListTile(
        title: Text(title),
        onTap: onTap,
      ),
    );
  }
}
