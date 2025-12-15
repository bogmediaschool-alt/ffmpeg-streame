import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/leaderboard_repository.dart';
import '../../auth/domain/app_user.dart';
import '../../auth/application/auth_controller.dart';

final leaderboardRepositoryProvider = Provider<LeaderboardRepository>((ref) {
  return LeaderboardRepository(FirebaseFirestore.instance);
});

final leaderboardProvider = FutureProvider<List<AppUser>>((ref) {
  return ref.read(leaderboardRepositoryProvider).topUsers(limit: 10);
});

final yourRankProvider = FutureProvider<int?>((ref) async {
  final user = ref.watch(authControllerProvider).value;
  if (user == null) return null;
  final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .orderBy('xp', descending: true)
      .get();
  final index = snapshot.docs.indexWhere((doc) => doc.id == user.id);
  return index == -1 ? null : index + 1;
});
