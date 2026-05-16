import 'package:flutter/material.dart';

class SleepEntry {
  final String id;
  final DateTime date;
  final int quality;
  final TimeOfDay? bedtime;
  final TimeOfDay? wakeup;
  final String? note;
  final DateTime createdAt;

  const SleepEntry({
    required this.id,
    required this.date,
    required this.quality,
    this.bedtime,
    this.wakeup,
    this.note,
    required this.createdAt,
  });

  int? get durationMinutes {
    if (bedtime == null || wakeup == null) return null;
    final bed = bedtime!.hour * 60 + bedtime!.minute;
    final wake = wakeup!.hour * 60 + wakeup!.minute;
    // wakeup < bedtime means crossed midnight (normal overnight sleep)
    return wake > bed ? wake - bed : (24 * 60 - bed) + wake;
  }

  String? get durationFormatted {
    final mins = durationMinutes;
    if (mins == null) return null;
    final h = mins ~/ 60;
    final m = mins % 60;
    if (h == 0) return '${m}м';
    if (m == 0) return '${h}ч';
    return '${h}ч ${m}м';
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': date.toIso8601String(),
        'quality': quality,
        'bedtimeMinutes':
            bedtime != null ? bedtime!.hour * 60 + bedtime!.minute : null,
        'wakeupMinutes':
            wakeup != null ? wakeup!.hour * 60 + wakeup!.minute : null,
        'note': note,
        'createdAt': createdAt.toIso8601String(),
      };

  factory SleepEntry.fromMap(Map<String, dynamic> map) {
    final bedMin = map['bedtimeMinutes'] as int?;
    final wakeMin = map['wakeupMinutes'] as int?;
    return SleepEntry(
      id: map['id'] as String,
      date: DateTime.parse(map['date'] as String),
      quality: map['quality'] as int,
      bedtime:
          bedMin != null ? TimeOfDay(hour: bedMin ~/ 60, minute: bedMin % 60) : null,
      wakeup:
          wakeMin != null ? TimeOfDay(hour: wakeMin ~/ 60, minute: wakeMin % 60) : null,
      note: map['note'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
