import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        children: const [
          _CategoryCard(
            title: 'Йога',
            subtitle: '12 уроков',
            icon: Icons.self_improvement,
            color: Color(0xFF2D6A4F),
          ),
          SizedBox(height: 12),
          _CategoryCard(
            title: 'Питание',
            subtitle: '8 уроков',
            icon: Icons.restaurant_outlined,
            color: Color(0xFF52B788),
          ),
          SizedBox(height: 12),
          _CategoryCard(
            title: 'Привычки',
            subtitle: '10 уроков',
            icon: Icons.loop,
            color: Color(0xFF74C69D),
          ),
          SizedBox(height: 12),
          _CategoryCard(
            title: 'Медитация',
            subtitle: '6 уроков',
            icon: Icons.spa_outlined,
            color: Color(0xFF40916C),
          ),
          SizedBox(height: 12),
          _CategoryCard(
            title: 'Сон и восстановление',
            subtitle: '5 уроков',
            icon: Icons.nightlight_outlined,
            color: Color(0xFF1B4332),
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

  const _CategoryCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
