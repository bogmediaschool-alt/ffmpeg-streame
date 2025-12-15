import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../domain/quest_task.dart';
import '../domain/quest_submission.dart';

class QuestRepository {
  QuestRepository(this._firestore);

  final FirebaseFirestore _firestore;

  Future<List<QuestTask>> fetchTodayTasks(int grade) async {
    final today = DateTime.now();
    final dateId = _formatDate(today);
    final snapshot = await _firestore
        .collection('dailyQuests')
        .doc(dateId)
        .collection('tasks')
        .orderBy('id')
        .get();
    if (snapshot.docs.isEmpty) {
      return _loadLocalFallback(today, grade);
    }
    return snapshot.docs
        .map((e) => QuestTask.fromJson(e.data()))
        .where((task) => task.gradeRange.contains(grade))
        .toList();
  }

  Future<List<QuestTask>> _loadLocalFallback(DateTime date, int grade) async {
    final jsonString = await rootBundle.loadString('assets/seed/daily_quests.json');
    final list = jsonDecode(jsonString) as List<dynamic>;
    final match = list.cast<Map<String, dynamic>?>().firstWhere(
          (map) => map?['date'] == _formatDate(date),
          orElse: () => null,
        );
    if (match == null) return [];
    final tasksJson = match['tasks'] as List<dynamic>;
    return tasksJson
        .map((e) => QuestTask.fromJson(e as Map<String, dynamic>))
        .where((task) => task.gradeRange.contains(grade))
        .toList();
  }

  Future<void> saveSubmission(QuestSubmission submission) async {
    await _firestore
        .collection('submissions')
        .doc(submission.userId)
        .collection(_formatDate(submission.date))
        .doc('result')
        .set(submission.toJson());
  }

  static String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
