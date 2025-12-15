class QuestTask {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final int points;
  final List<int> gradeRange;

  const QuestTask({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.points,
    required this.gradeRange,
  });

  factory QuestTask.fromJson(Map<String, dynamic> json) {
    return QuestTask(
      id: json['id'] as String,
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List<dynamic>),
      correctIndex: json['correctIndex'] as int,
      explanation: json['explanation'] as String,
      points: json['points'] as int,
      gradeRange: List<int>.from(json['gradeRange'] as List<dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctIndex': correctIndex,
      'explanation': explanation,
      'points': points,
      'gradeRange': gradeRange,
    };
  }
}
