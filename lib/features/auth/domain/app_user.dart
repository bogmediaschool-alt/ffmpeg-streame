class AppUser {
  final String id;
  final String? email;
  final String nickname;
  final int grade;
  final String avatarId;
  final int xp;
  final int level;
  final int streak;
  final DateTime? lastCompletedDate;
  final DateTime createdAt;

  const AppUser({
    required this.id,
    this.email,
    required this.nickname,
    required this.grade,
    required this.avatarId,
    required this.xp,
    required this.level,
    required this.streak,
    required this.lastCompletedDate,
    required this.createdAt,
  });

  factory AppUser.initial(String id, {String? email}) {
    return AppUser(
      id: id,
      email: email,
      nickname: 'Explorer',
      grade: 5,
      avatarId: 'avatar_1',
      xp: 0,
      level: 1,
      streak: 0,
      lastCompletedDate: null,
      createdAt: DateTime.now(),
    );
  }

  AppUser copyWith({
    String? nickname,
    int? grade,
    String? avatarId,
    int? xp,
    int? level,
    int? streak,
    DateTime? lastCompletedDate,
  }) {
    return AppUser(
      id: id,
      email: email,
      nickname: nickname ?? this.nickname,
      grade: grade ?? this.grade,
      avatarId: avatarId ?? this.avatarId,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      streak: streak ?? this.streak,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'grade': grade,
      'avatarId': avatarId,
      'xp': xp,
      'level': level,
      'streak': streak,
      'lastCompletedDate': lastCompletedDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'email': email,
    };
  }

  factory AppUser.fromJson(String id, Map<String, dynamic> json) {
    return AppUser(
      id: id,
      email: json['email'] as String?,
      nickname: json['nickname'] as String? ?? 'Explorer',
      grade: json['grade'] as int? ?? 5,
      avatarId: json['avatarId'] as String? ?? 'avatar_1',
      xp: json['xp'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      streak: json['streak'] as int? ?? 0,
      lastCompletedDate: json['lastCompletedDate'] != null
          ? DateTime.tryParse(json['lastCompletedDate'] as String)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }
}
