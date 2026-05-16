import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/sleep_entry.dart';
import '../services/sleep_service.dart';
import '../theme/colors.dart';

class SleepHistoryList extends StatelessWidget {
  final SleepService service;

  const SleepHistoryList({super.key, required this.service});

  static const _dotColors = [
    YgeiaColors.accentSecondary,
    Color(0xFFDDB49F),
    YgeiaColors.bgCard,
    Color(0xFFA6B6A6),
    YgeiaColors.accent,
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SleepEntry>>(
      stream: service.getRecentSleeps(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }
        final entries = snapshot.data ?? [];
        if (entries.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Здесь будет твоя история сна',
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
                  _SleepEntryRow(entry: entry, dotColors: _dotColors),
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

class _SleepEntryRow extends StatelessWidget {
  final SleepEntry entry;
  final List<Color> dotColors;

  const _SleepEntryRow({required this.entry, required this.dotColors});

  @override
  Widget build(BuildContext context) {
    final dotColor = dotColors[(entry.quality - 1).clamp(0, 4)];
    final duration = entry.durationFormatted;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Container(
              width: 16,
              height: 16,
              decoration:
                  BoxDecoration(color: dotColor, shape: BoxShape.circle),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _formatDate(entry.date),
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: YgeiaColors.textPrimary,
                      ),
                    ),
                    if (duration != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        duration,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: YgeiaColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
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
      '',
      'янв',
      'фев',
      'мар',
      'апр',
      'мая',
      'июн',
      'июл',
      'авг',
      'сен',
      'окт',
      'ноя',
      'дек'
    ];
    return '${weekdays[date.weekday]} ${date.day} ${months[date.month]}';
  }
}
