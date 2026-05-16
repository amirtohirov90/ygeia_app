import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/mood_entry.dart';
import '../services/mood_service.dart';
import '../theme/colors.dart';

class MoodHistoryList extends StatelessWidget {
  final MoodService service;

  const MoodHistoryList({super.key, required this.service});

  static const _dotColors = [
    YgeiaColors.accentSecondary,
    Color(0xFFDDB49F),
    YgeiaColors.bgCard,
    Color(0xFFA6B6A6),
    YgeiaColors.accent,
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MoodEntry>>(
      stream: service.getRecentMoods(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }
        final entries = snapshot.data ?? [];
        if (entries.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Здесь будет твоя история',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: YgeiaColors.textMuted,
              ),
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Последние записи',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: YgeiaColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            ...List.generate(entries.length, (i) {
              final entry = entries[i];
              final isLast = i == entries.length - 1;
              return Column(
                children: [
                  _EntryRow(entry: entry, dotColors: _dotColors),
                  if (!isLast)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: YgeiaColors.divider,
                    ),
                ],
              );
            }),
          ],
        );
      },
    );
  }
}

class _EntryRow extends StatelessWidget {
  final MoodEntry entry;
  final List<Color> dotColors;

  const _EntryRow({required this.entry, required this.dotColors});

  @override
  Widget build(BuildContext context) {
    final dotColor = dotColors[(entry.level - 1).clamp(0, 4)];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
      child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _formatDate(entry.date),
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: YgeiaColors.textPrimary,
                    ),
                  ),
                  if (entry.note != null && entry.note!.isNotEmpty)
                    Text(
                      entry.note!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: YgeiaColors.textMuted,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final entryDay = DateTime(date.year, date.month, date.day);
    final diff = today.difference(entryDay).inDays;

    if (diff == 0) return 'Сегодня';
    if (diff == 1) return 'Вчера';

    const weekdays = ['', 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    const months = [
      '', 'янв', 'фев', 'мар', 'апр', 'мая',
      'июн', 'июл', 'авг', 'сен', 'окт', 'ноя', 'дек'
    ];
    return '${weekdays[date.weekday]} ${date.day} ${months[date.month]}';
  }
}
