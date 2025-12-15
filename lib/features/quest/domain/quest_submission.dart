class QuestSubmission {
  final String userId;
  final DateTime date;
  final int score;
  final int totalPoints;
  final bool completed;

  const QuestSubmission({
    required this.userId,
    required this.date,
    required this.score,
    required this.totalPoints,
    required this.completed,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'date': date.toIso8601String(),
      'score': score,
      'totalPoints': totalPoints,
      'completed': completed,
    };
  }
}
