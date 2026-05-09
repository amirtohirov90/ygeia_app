import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'lesson_detail_screen.dart';

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
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const LessonDetailScreen(
                  category: 'Йога',
                  color: Color(0xFF2D6A4F),
                  icon: Icons.self_improvement,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _CategoryCard(
            title: 'Питание',
            subtitle: '5 уроков',
            icon: Icons.restaurant_outlined,
            color: const Color(0xFF52B788),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const LessonDetailScreen(
                  category: 'Питание',
                  color: Color(0xFF52B788),
                  icon: Icons.restaurant_outlined,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _CategoryCard(
            title: 'Привычки',
            subtitle: '5 уроков',
            icon: Icons.loop,
            color: const Color(0xFF74C69D),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const LessonDetailScreen(
                  category: 'Привычки',
                  color: Color(0xFF74C69D),
                  icon: Icons.loop,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _CategoryCard(
            title: 'Медитация',
            subtitle: '4 урока',
            icon: Icons.spa_outlined,
            color: const Color(0xFF40916C),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const LessonDetailScreen(
                  category: 'Медитация',
                  color: Color(0xFF40916C),
                  icon: Icons.spa_outlined,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _CategoryCard(
            title: 'Сон и восстановление',
            subtitle: '4 урока',
            icon: Icons.nightlight_outlined,
            color: const Color(0xFF1B4332),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const LessonDetailScreen(
                  category: 'Сон и восстановление',
                  color: Color(0xFF1B4332),
                  icon: Icons.nightlight_outlined,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
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
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
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
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFF999999),
            ),
          ],
        ),
      ),
    );
  }
}
