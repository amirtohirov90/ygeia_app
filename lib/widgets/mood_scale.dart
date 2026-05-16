import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';

class MoodScale extends StatelessWidget {
  final int? selected;
  final ValueChanged<int> onChanged;

  const MoodScale({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  static const _labels = ['Тяжело', 'Сложно', 'Ровно', 'Хорошо', 'Прекрасно'];

  // Level 2: lerp(accentSecondary, bgCard, 0.5) = (#C97B5C + #F2EDE3) / 2
  // Level 4: lerp(bgCard, accent, 0.5) = (#F2EDE3 + #5B7F6A) / 2
  static const _dotColors = [
    YgeiaColors.accentSecondary,
    Color(0xFFDDB49F),
    YgeiaColors.bgCard,
    Color(0xFFA6B6A6),
    YgeiaColors.accent,
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (i) {
        final level = i + 1;
        final isSelected = selected == level;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(level),
            behavior: HitTestBehavior.opaque,
            child: Column(
              children: [
                Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    width: isSelected ? 56.0 : 44.0,
                    height: isSelected ? 56.0 : 44.0,
                    decoration: BoxDecoration(
                      color: _dotColors[i],
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _labels[i],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? YgeiaColors.textPrimary
                        : YgeiaColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
