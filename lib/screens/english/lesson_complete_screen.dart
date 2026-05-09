import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LessonCompleteScreen extends StatefulWidget {
  final String lessonTitle;
  final int mistakes;
  final int totalExercises;
  final int xpEarned;
  final int stars;
  final Color unitColor;

  const LessonCompleteScreen({
    super.key,
    required this.lessonTitle,
    required this.mistakes,
    required this.totalExercises,
    required this.xpEarned,
    required this.stars,
    required this.unitColor,
  });

  @override
  State<LessonCompleteScreen> createState() => _LessonCompleteScreenState();
}

class _LessonCompleteScreenState extends State<LessonCompleteScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _starsController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _starsController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _scaleAnim = CurvedAnimation(
        parent: _scaleController, curve: Curves.elasticOut);

    // Play animations in sequence
    Future.delayed(const Duration(milliseconds: 200), () {
      _scaleController.forward();
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      _starsController.forward();
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _starsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final correct = widget.totalExercises - widget.mistakes;
    final accuracy = ((correct / widget.totalExercises) * 100).round();

    return Scaffold(
      backgroundColor: const Color(0xFFF0E8DA),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(height: 32),

                      // Trophy icon
                      ScaleTransition(
                        scale: _scaleAnim,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: widget.unitColor.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              widget.stars == 3
                                  ? '🏆'
                                  : widget.stars == 2
                                      ? '⭐'
                                      : '✅',
                              style: const TextStyle(fontSize: 56),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Text(
                        widget.stars == 3
                            ? 'Отлично!'
                            : widget.stars == 2
                                ? 'Хорошая работа!'
                                : 'Урок пройден!',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.lessonTitle,
                        style: GoogleFonts.inter(
                            fontSize: 15, color: const Color(0xFF888888)),
                      ),

                      const SizedBox(height: 28),

                      // Stars row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (i) {
                          return AnimatedBuilder(
                            animation: _starsController,
                            builder: (context, child) {
                              final delay = i * 0.2;
                              final progress =
                                  (((_starsController.value - delay) / 0.6)
                                          .clamp(0.0, 1.0));
                              return Transform.scale(
                                scale: Curves.elasticOut.transform(progress),
                                child: child,
                              );
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              child: Icon(
                                i < widget.stars
                                    ? Icons.star_rounded
                                    : Icons.star_outline_rounded,
                                size: 52,
                                color: i < widget.stars
                                    ? const Color(0xFFFFB700)
                                    : const Color(0xFFDDD5C8),
                              ),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 28),

                      // Stats row
                      Row(
                        children: [
                          _StatCard(
                            icon: Icons.bolt_rounded,
                            iconColor: const Color(0xFFFFB700),
                            label: 'XP заработано',
                            value: '+${widget.xpEarned}',
                          ),
                          const SizedBox(width: 12),
                          _StatCard(
                            icon: Icons.check_circle_rounded,
                            iconColor: const Color(0xFF52B788),
                            label: 'Точность',
                            value: '$accuracy%',
                          ),
                          const SizedBox(width: 12),
                          _StatCard(
                            icon: Icons.close_rounded,
                            iconColor: const Color(0xFFE63946),
                            label: 'Ошибки',
                            value: '${widget.mistakes}',
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Encouragement text
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: widget.unitColor.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: widget.unitColor.withOpacity(0.2)),
                        ),
                        child: Text(
                          widget.stars == 3
                              ? '🔥 Идеальный результат! Ты освоил этот урок на отлично.'
                              : widget.stars == 2
                                  ? '💪 Неплохо! Повтори урок ещё раз, чтобы получить 3 звезды.'
                                  : '📚 Не сдавайся! Практика делает совершенным.',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: widget.unitColor,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Pop lesson_complete and go back to home
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.unitColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: Text('Продолжить',
                          style: GoogleFonts.inter(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFAF4EC),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(height: 6),
            Text(
              value,
              style: GoogleFonts.playfairDisplay(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A1A)),
            ),
            Text(
              label,
              style: GoogleFonts.inter(
                  fontSize: 10, color: const Color(0xFF999999)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
