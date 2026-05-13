import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../config/feature_flags.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import 'lesson_detail_screen.dart';
import 'english/english_home_screen.dart';

class LessonsScreen extends StatelessWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YgeiaColors.bgBase,
      appBar: AppBar(
        title: Text('Уроки', style: YgeiaTypography.h2),
        backgroundColor: YgeiaColors.bgBase,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── English module (hidden until kEnglishEnabled) ──────────
          if (FeatureFlags.kEnglishEnabled)
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const EnglishHomeScreen()),
              ),
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1565C0), Color(0xFF1976D2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1565C0).withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Icon(Icons.language,
                            color: Colors.white, size: 32),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Английский язык',
                              style: GoogleFonts.fraunces(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                          const SizedBox(height: 4),
                          Text('5 уровней · 20 уроков',
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.75))),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text('Начать →',
                                style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // ── Wellness categories ────────────────────────────────────
          _CategoryCard(
            title: 'Йога',
            subtitle: '5 уроков',
            icon: Icons.self_improvement,
            color: YgeiaColors.accent,
            isPremium: false,
            onTap: () =>
                _open(context, 'Йога', YgeiaColors.accent, Icons.self_improvement),
          ),
          const SizedBox(height: 12),
          _CategoryCard(
            title: 'Питание',
            subtitle: '5 уроков',
            icon: Icons.restaurant_outlined,
            color: const Color(0xFF52B788),
            isPremium: false,
            onTap: () => _open(context, 'Питание',
                const Color(0xFF52B788), Icons.restaurant_outlined),
          ),
          const SizedBox(height: 12),
          _CategoryCard(
            title: 'Привычки',
            subtitle: '5 уроков',
            icon: Icons.loop,
            color: const Color(0xFF74C69D),
            isPremium: false,
            onTap: () => _open(
                context, 'Привычки', const Color(0xFF74C69D), Icons.loop),
          ),
          const SizedBox(height: 12),
          _CategoryCard(
            title: 'Медитация',
            subtitle: '4 урока · Клуб',
            icon: Icons.spa_outlined,
            color: YgeiaColors.accent,
            isPremium: true,
            onTap: () => _openPremium(context),
          ),
          const SizedBox(height: 12),
          _CategoryCard(
            title: 'Сон и восстановление',
            subtitle: '4 урока · Клуб',
            icon: Icons.nightlight_outlined,
            color: const Color(0xFF1B4332),
            isPremium: true,
            onTap: () => _openPremium(context),
          ),
          const SizedBox(height: 16),

          // ── Club CTA ───────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: YgeiaColors.accentSoft,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: YgeiaColors.accent.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.lock, color: YgeiaColors.accent, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Открой все уроки',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: YgeiaColors.textPrimary,
                          )),
                      Text('Вступи в закрытый клуб ygeia',
                          style: YgeiaTypography.bodySmall),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => _openPremium(context),
                  child: Text('Подробнее',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: YgeiaColors.accent,
                      )),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _open(BuildContext context, String cat, Color color, IconData icon) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, __) =>
            LessonDetailScreen(category: cat, color: color, icon: icon),
        transitionsBuilder: (_, animation, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        ),
      ),
    );
  }

  void _openPremium(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: YgeiaColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: YgeiaColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Icon(LucideIcons.lock, color: YgeiaColors.accent, size: 44),
            const SizedBox(height: 16),
            Text(
              'Только для участников клуба',
              style: YgeiaTypography.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Этот раздел доступен участникам закрытого клуба ygeia. Вступи, чтобы получить доступ ко всем урокам.',
              style: YgeiaTypography.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Понятно'),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isPremium;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.isPremium,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: YgeiaColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(isPremium ? 0.05 : 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isPremium ? color.withOpacity(0.4) : color,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.fraunces(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isPremium
                          ? YgeiaColors.textMuted
                          : YgeiaColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: YgeiaTypography.caption),
                ],
              ),
            ),
            isPremium
                ? const Icon(Icons.lock_outline,
                    size: 18, color: YgeiaColors.textMuted)
                : const Icon(Icons.arrow_forward_ios,
                    size: 16, color: YgeiaColors.textMuted),
          ],
        ),
      ),
    );
  }
}
