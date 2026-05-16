class JournalEntry {
  final String id;
  final String text;
  final DateTime createdAt;

  const JournalEntry({
    required this.id,
    required this.text,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'text': text,
        'createdAt': createdAt.toIso8601String(),
      };

  factory JournalEntry.fromMap(Map<String, dynamic> map) => JournalEntry(
        id: map['id'] as String,
        text: map['text'] as String,
        createdAt: DateTime.parse(map['createdAt'] as String),
      );
}
