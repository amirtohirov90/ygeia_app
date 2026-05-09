import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/english_content.dart';
import '../../models/english_models.dart';
import '../../services/english_service.dart';
import 'lesson_screen.dart';

class EnglishHomeScreen extends StatefulWidget {
  const EnglishHomeScreen({super.key});

  @override
  State<EnglishHomeScreen> createState() => _EnglishHomeScreenState();
}

class _EnglishHomeScreenState extends State<EnglishHomeScreen> {
  final _service = EnglishService();
  EnglishProgress _progress = EnglishProgress.empty();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await _service.getProgress();
    if (mounted) setState(() { _progress = p; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0E8DA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D6A4F),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Английский язык',
          style: GoogleFonts.playfairDisplay(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          // XP badge
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.bolt, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text('${_progress.totalXp} XP',
                    style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF2D6A4F)))
          : RefreshIndicator(
              onRefresh: _load,
              child: CustomScrollView(
                slivers: [
                  // Streak banner
                  SliverToBoxAdapter(child: _buildStreakBanner()),
                  // Units
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => _UnitCard(
                        unit: englishUnits[i],
                        progress: _progress,
                        service: _service,
                        onLessonDone: _load,
                      ),
                      childCount: englishUnits.length,
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 32)),
                ],
              ),
            ),
    );
  }

  Widget _buildStreakBanner() {
    if (_progress.currentStreak == 0) return const SizedBox(height: 8);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFF6B35).withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFF6B35).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Text('🔥', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${_progress.currentStreak} дней подряд!',
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFCC4A0C))),
              Text('Не прерывай серию — занимайся каждый день',
                  style: GoogleFonts.inter(
                      fontSize: 11, color: const Color(0xFF888888))),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
class _UnitCard extends StatelessWidget {
  final EnglishUnit unit;
  final EnglishProgress progress;
  final EnglishService service;
  final VoidCallback onLessonDone;

  const _UnitCard({
    required this.unit,
    required this.progress,
    required this.service,
    required this.onLessonDone,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(unit.colorValue);
    final completedLessons =
        unit.lessons.where((l) => progress.lessons[l.id]?.completed == true).length;
    final isUnitDone = completedLessons == unit.lessons.length;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF4EC),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Unit header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(unit.emoji,
                        style: const TextStyle(fontSize: 26)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(unit.title,
                          style: GoogleFonts.playfairDisplay(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1A1A1A))),
                      Text(unit.description,
                          style: GoogleFonts.inter(
                              fontSize: 12, color: const Color(0xFF888888))),
                    ],
                  ),
                ),
                if (isUnitDone)
                  const Icon(Icons.verified_rounded,
                      color: Color(0xFF52B788), size: 24),
              ],
            ),
          ),
          // Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: completedLessons / unit.lessons.length,
                      minHeight: 6,
                      backgroundColor: color.withOpacity(0.12),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text('$completedLessons/${unit.lessons.length}',
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF888888))),
              ],
            ),
          ),
          // Lessons
          ...unit.lessons.asMap().entries.map((entry) {
            final lesson = entry.value;
            final lp = progress.lessons[lesson.id];
            final isCompleted = lp?.completed == true;
            final isUnlocked = service.isLessonUnlocked(lesson.id, progress);
            return _LessonTile(
              lesson: lesson,
              progress: lp,
              isUnlocked: isUnlocked,
              unitColor: color,
              onTap: isUnlocked
                  ? () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LessonScreen(
                            lesson: lesson,
                            unitColor: color,
                          ),
                        ),
                      );
                      onLessonDone();
                    }
                  : null,
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
class _LessonTile extends StatelessWidget {
  final EnglishLesson lesson;
  final LessonProgress? progress;
  final bool isUnlocked;
  final Color unitColor;
  final VoidCallback? onTap;

  const _LessonTile({
    required this.lesson,
    required this.progress,
    required this.isUnlocked,
    required this.unitColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = progress?.completed == true;
    final stars = progress?.stars ?? 0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // Icon circle
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isUnlocked
                    ? (isCompleted
                        ? unitColor.withOpacity(0.15)
                        : const Color(0xFFF0E8DA))
                    : const Color(0xFFEEEEEE),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isUnlocked ? unitColor.withOpacity(0.4) : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: isUnlocked
                    ? Text(lesson.emoji,
                        style: TextStyle(
                            fontSize: 20,
                            color: isUnlocked ? null : Colors.grey))
                    : const Icon(Icons.lock_outline,
                        size: 18, color: Color(0xFFBBBBBB)),
              ),
            ),
            const SizedBox(width: 14),
            // Title + stars
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isUnlocked
                          ? const Color(0xFF1A1A1A)
                          : const Color(0xFFBBBBBB),
                    ),
                  ),
                  if (isCompleted)
                    Row(
                      children: List.generate(
                        3,
                        (i) => Icon(
                          i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
                          size: 14,
                          color: i < stars
                              ? const Color(0xFFFFB700)
                              : const Color(0xFFDDD5C8),
                        ),
                      ),
                    )
                  else
                    Text(
                      isUnlocked ? '${lesson.exercises.length} заданий' : 'Заблокировано',
                      style: GoogleFonts.inter(
                          fontSize: 11, color: const Color(0xFF999999)),
                    ),
                ],
              ),
            ),
            // Status icon
            if (isCompleted)
              Icon(Icons.check_circle_rounded,
                  color: unitColor, size: 20)
            else if (isUnlocked)
              Icon(Icons.arrow_forward_ios,
                  size: 14, color: unitColor.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }
}
