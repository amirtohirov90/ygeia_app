class MoodEntry {
  final String id;
  final DateTime date;
  final int level;
  final String? note;
  final DateTime createdAt;

  const MoodEntry({
    required this.id,
    required this.date,
    required this.level,
    this.note,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': date.toIso8601String(),
        'level': level,
        'note': note,
        'createdAt': createdAt.toIso8601String(),
      };

  factory MoodEntry.fromMap(Map<String, dynamic> map) => MoodEntry(
        id: map['id'] as String,
        date: DateTime.parse(map['date'] as String),
        level: map['level'] as int,
        note: map['note'] as String?,
        createdAt: DateTime.parse(map['createdAt'] as String),
      );
}
