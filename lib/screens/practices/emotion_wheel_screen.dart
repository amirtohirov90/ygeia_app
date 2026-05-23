import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/emotions_wheel.dart';
import '../../models/emotion_sector.dart';
import '../../services/journal_service.dart';
import '../../services/analytics_service.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import 'journal_screen.dart';

class EmotionWheelScreen extends StatefulWidget {
  const EmotionWheelScreen({super.key});

  @override
  State<EmotionWheelScreen> createState() => _EmotionWheelScreenState();
}

class _EmotionWheelScreenState extends State<EmotionWheelScreen> {
  int? _selectedIndex;
  bool _saving = false;

  // outerRadius = wheelSize / 2 = 160; innerRadius = 160 * 0.45 = 72
  static const double _wheelSize = 320;
  static const double _outerRadius = _wheelSize / 2;
  static const double _innerRadius = _outerRadius * 0.45;
  static const Offset _center = Offset(_outerRadius, _outerRadius);

  void _onTapDown(TapDownDetails details) {
    final dx = details.localPosition.dx - _center.dx;
    final dy = details.localPosition.dy - _center.dy;
    final distance = sqrt(dx * dx + dy * dy);

    // Ignore taps outside the donut ring
    if (distance < _innerRadius || distance > _outerRadius) return;

    // Shift atan2 so 0 = top, increasing clockwise
    // atan2 range: [-pi, pi]; adding pi/2 shifts 0 to "up"
    // Adding 2*pi then modulo ensures [0, 2*pi)
    final angle = (atan2(dy, dx) + pi / 2 + 2 * pi) % (2 * pi);
    final index = (angle / (2 * pi / kEmotions.length)).floor().clamp(0, 9);

    HapticFeedback.selectionClick();
    setState(() => _selectedIndex = index);
    AnalyticsService.logEmotionWheelUsed(kEmotions[index].name);
  }

  Future<void> _save() async {
    if (_selectedIndex == null || _saving) return;
    setState(() => _saving = true);
    final emotion = kEmotions[_selectedIndex!];
    await JournalService().addEntry('Я чувствую: ${emotion.name}');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Записано',
          style: GoogleFonts.inter(
              fontSize: 14, color: YgeiaColors.textPrimary),
        ),
        backgroundColor: YgeiaColors.bgCard,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        duration: const Duration(seconds: 2),
      ),
    );
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final selected =
        _selectedIndex != null ? kEmotions[_selectedIndex!] : null;

    // Pass pre-built TextStyle so GoogleFonts is resolved in widget tree
    final labelStyle = GoogleFonts.inter(
      fontSize: 9.0,
      height: 1.2,
      fontWeight: FontWeight.w500,
    );

    return Scaffold(
      backgroundColor: YgeiaColors.bgBase,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
        foregroundColor: YgeiaColors.textPrimary,
        title: Text.rich(
          TextSpan(children: [
            TextSpan(
              text: 'Э',
              style: GoogleFonts.fraunces(
                fontSize: 20,
                fontStyle: FontStyle.italic,
                color: YgeiaColors.textPrimary,
              ),
            ),
            TextSpan(
              text: 'моции',
              style: GoogleFonts.fraunces(
                fontSize: 20,
                color: YgeiaColors.textPrimary,
              ),
            ),
          ]),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                YgeiaSpacing.md,
                YgeiaSpacing.md,
                YgeiaSpacing.md,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Когда «хорошо / плохо» — слишком грубо.',
                    style: GoogleFonts.fraunces(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: YgeiaColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: YgeiaSpacing.sm),
                  Text(
                    'Прислушайся и выбери то, что ближе всего.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: YgeiaColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: YgeiaSpacing.xl),

            // ── Wheel ────────────────────────────────────────────────────
            Center(
              child: SizedBox(
                width: _wheelSize,
                height: _wheelSize,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    GestureDetector(
                      onTapDown: _onTapDown,
                      child: CustomPaint(
                        size: const Size(_wheelSize, _wheelSize),
                        painter: _WheelPainter(
                          emotions: kEmotions,
                          selectedIndex: _selectedIndex,
                          labelStyle: labelStyle,
                        ),
                      ),
                    ),

                    // Center hole — info text
                    SizedBox(
                      width: _innerRadius * 2 * 0.82,
                      child: selected == null
                          ? Text(
                              'Я чувствую...',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: YgeiaColors.textMuted,
                                fontStyle: FontStyle.italic,
                              ),
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Я чувствую',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: YgeiaColors.textMuted,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  selected.name,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.fraunces(
                                    fontSize: 22,
                                    fontStyle: FontStyle.italic,
                                    color: YgeiaColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: YgeiaSpacing.xl),

            // ── Save button ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: YgeiaSpacing.md),
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: (_selectedIndex != null && !_saving)
                      ? _save
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: YgeiaColors.accent,
                    disabledBackgroundColor: YgeiaColors.divider,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: YgeiaColors.white,
                          ),
                        )
                      : Text(
                          _selectedIndex == null
                              ? 'Выбери эмоцию'
                              : 'Записать · ${kEmotions[_selectedIndex!].name}',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: _selectedIndex != null
                                ? YgeiaColors.white
                                : YgeiaColors.textMuted,
                          ),
                        ),
                ),
              ),
            ),

            const SizedBox(height: YgeiaSpacing.md),

            Center(
              child: TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    settings: const RouteSettings(name: '/journal'),
                    builder: (_) => const JournalScreen(),
                  ),
                ),
                child: Text(
                  'или опиши своими словами',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: YgeiaColors.textMuted,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── CustomPainter ──────────────────────────────────────────────────────────

class _WheelPainter extends CustomPainter {
  final List<EmotionSector> emotions;
  final int? selectedIndex;
  final TextStyle labelStyle;

  _WheelPainter({
    required this.emotions,
    required this.labelStyle,
    this.selectedIndex,
  });

  // Small angular gap (radians) between adjacent sectors
  static const double _gap = 0.018;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;
    final innerRadius = outerRadius * 0.45;
    final sectorAngle = 2 * pi / emotions.length;

    for (int i = 0; i < emotions.length; i++) {
      final isSelected = selectedIndex == i;
      final emotion = emotions[i];

      // Each sector starts at the top (-pi/2) and goes clockwise
      final startAngle = -pi / 2 + i * sectorAngle + _gap / 2;
      final sweep = sectorAngle - _gap;

      // ── Donut sector path ────────────────────────────────────────────
      // 1. Move to outer arc start
      // 2. Outer arc clockwise
      // 3. Line to inner arc end
      // 4. Inner arc counter-clockwise back to start
      // 5. Close
      final path = Path()
        ..moveTo(
          center.dx + outerRadius * cos(startAngle),
          center.dy + outerRadius * sin(startAngle),
        )
        ..arcTo(
          Rect.fromCircle(center: center, radius: outerRadius),
          startAngle,
          sweep,
          false,
        )
        ..lineTo(
          center.dx + innerRadius * cos(startAngle + sweep),
          center.dy + innerRadius * sin(startAngle + sweep),
        )
        ..arcTo(
          Rect.fromCircle(center: center, radius: innerRadius),
          startAngle + sweep,
          -sweep,
          false,
        )
        ..close();

      // Fill
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.fill
          ..color = isSelected
              ? emotion.color
              : emotion.color.withValues(alpha: 0.55),
      );

      // Selected sector: accent border
      if (isSelected) {
        canvas.drawPath(
          path,
          Paint()
            ..style = PaintingStyle.stroke
            ..color = YgeiaColors.accent
            ..strokeWidth = 2.5
            ..strokeJoin = StrokeJoin.round,
        );
      }

      // ── Text label — horizontal, centred in sector ───────────────────
      final midAngle = startAngle + sweep / 2;
      final midRadius = (innerRadius + outerRadius) / 2;
      final textCenter = Offset(
        center.dx + midRadius * cos(midAngle),
        center.dy + midRadius * sin(midAngle),
      );

      // Available width ≈ chord at mid radius
      final chordWidth = 2 * midRadius * sin(sweep / 2);

      final tp = TextPainter(
        text: TextSpan(
          text: emotion.name,
          style: labelStyle.copyWith(
            color: Colors.white.withValues(alpha: isSelected ? 1.0 : 0.85),
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
        maxLines: 2,
      )..layout(maxWidth: chordWidth * 1.1);

      tp.paint(
        canvas,
        textCenter - Offset(tp.width / 2, tp.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WheelPainter old) =>
      old.selectedIndex != selectedIndex;
}
