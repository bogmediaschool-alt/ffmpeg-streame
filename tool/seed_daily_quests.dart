import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../lib/firebase_options.dart';

Future<void> main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final firestore = FirebaseFirestore.instance;
  final seeds = await File('assets/seed/daily_quests.json').readAsString();
  final list = jsonDecode(seeds) as List<dynamic>;
  for (final day in list) {
    final date = day['date'] as String;
    final tasks = day['tasks'] as List<dynamic>;
    for (final task in tasks) {
      final id = task['id'] as String;
      await firestore
          .collection('dailyQuests')
          .doc(date)
          .collection('tasks')
          .doc(id)
          .set(task as Map<String, dynamic>);
    }
  }
  print('Seeded ${list.length} day(s).');
}
