import 'package:cloud_firestore/cloud_firestore.dart';

import '../../auth/domain/app_user.dart';

class LeaderboardRepository {
  LeaderboardRepository(this._firestore);

  final FirebaseFirestore _firestore;

  Future<List<AppUser>> topUsers({int limit = 10}) async {
    final snapshot = await _firestore
        .collection('users')
        .orderBy('xp', descending: true)
        .limit(limit)
        .get();
    return snapshot.docs
        .map((doc) => AppUser.fromJson(doc.id, doc.data()))
        .toList();
  }
}
