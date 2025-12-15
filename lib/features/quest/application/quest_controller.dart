import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/application/auth_controller.dart';
import '../data/quest_repository.dart';
import '../domain/quest_submission.dart';
import '../domain/quest_task.dart';

final questRepositoryProvider = Provider<QuestRepository>((ref) {
  return QuestRepository(FirebaseFirestore.instance);
});

final todayTasksProvider = FutureProvider<List<QuestTask>>((ref) async {
  final user = ref.watch(authControllerProvider).value;
  final grade = user?.grade ?? 5;
  return ref.read(questRepositoryProvider).fetchTodayTasks(grade);
});

class QuestProgress extends StateNotifier<int> {
  QuestProgress() : super(0);

  void next() => state++;
  void reset() => state = 0;
}

final questProgressProvider = StateNotifierProvider<QuestProgress, int>((ref) => QuestProgress());

class QuestSubmissionController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> submit({required int score, required int totalPoints}) async {
    final user = ref.read(authControllerProvider).value;
    if (user == null) return;
    final submission = QuestSubmission(
      userId: user.id,
      date: DateTime.now(),
      score: score,
      totalPoints: totalPoints,
      completed: true,
    );
    await ref.read(questRepositoryProvider).saveSubmission(submission);
  }
}

final questSubmissionProvider = AsyncNotifierProvider<QuestSubmissionController, void>(QuestSubmissionController.new);
