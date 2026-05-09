import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'lesson_detail_screen.dart';
import 'club_screen.dart';

class LessonsScreen extends StatelessWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D6A4F),
        title: Text(
          'Уроки',
          style: GoogleFonts.playfairDisplay(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _CategoryCard(
            title: 'Йога',
            subtitle: '5 уроков',
            icon: Icons.self_improvement,
            color: const Color(0xFF2D6A4F),
            isPremium: false,
            onTap: () => _open(context, 'Йога', const Color(0xFF2D6A4F),
                Icons.self_improvement),
          ),
          const SizedBox(height: 12),
          _CategoryCard(
            title: 'Питание',
            subtitle: '5 уроков',
            icon: Icons.restaurant_outlined,
            color: const Color(0xFF52B788),
            isPremium: false,
            onTap: () => _open(context, 'Питание', const Color(0xFF52B788),
                Icons.restaurant_outlined),
          ),
          const SizedBox(height: 12),
          _CategoryCard(
            title: 'Привычки',
            subtitle: '5 уроков',
            icon: Icons.loop,
            color: const Color(0xFF74C69D),
            isPremium: false,
            onTap: () => _open(context, 'Привычки', const Color(0xFF74C69D),
                Icons.loop),
          ),
          const SizedBox(height: 12),
          _CategoryCard(
            title: 'Медитация',
            subtitle: '4 урока • Клуб',
            icon: Icons.spa_outlined,
            color: const Color(0xFF40916C),
            isPremium: true,
            onTap: () => _openPremium(context),
          ),
          const SizedBox(height: 12),
          _CategoryCard(
            title: 'Сон и восстановление',
            subtitle: '4 урока • Клуб',
            icon: Icons.nightlight_outlined,
            color: const Color(0xFF1B4332),
            isPremium: true,
            onTap: () => _openPremium(context),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF2D6A4F).withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFF2D6A4F).withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.stars, color: Color(0xFF2D6A4F), size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Открой все уроки',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                      Text(
                        'Вступи в закрытый клуб ygeia',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => _openPremium(context),
                  child: Text(
                    'Подробнее',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2D6A4F),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _open(
      BuildContext context, String cat, Color color, IconData icon) {
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
      backgroundColor: Colors.white,
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
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Icon(Icons.stars, color: Color(0xFF2D6A4F), size: 44),
            const SizedBox(height: 16),
            Text(
              'Только для участников клуба',
              style: GoogleFonts.playfairDisplay(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A1A1A),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Этот раздел доступен участникам закрытого клуба ygeia. Вступи, чтобы получить доступ ко всем урокам.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF666666),
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ClubScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D6A4F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Вступить в клуб',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
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
                color: color.withOpacity(isPremium ? 0.06 : 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon,
                  color: isPremium
                      ? color.withOpacity(0.5)
                      : color,
                  size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isPremium
                          ? const Color(0xFF999999)
                          : const Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: const Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            ),
            isPremium
                ? const Icon(Icons.lock_outline,
                    size: 18, color: Color(0xFFCCCCCC))
                : const Icon(Icons.arrow_forward_ios,
                    size: 16, color: Color(0xFF999999)),
          ],
        ),
      ),
    );
  }
}
