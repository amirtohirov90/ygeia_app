import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D6A4F),
        title: Text(
          'Профиль',
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
          const SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: const Color(0xFF2D6A4F).withOpacity(0.12),
                  child: const Icon(
                    Icons.person,
                    size: 48,
                    color: Color(0xFF2D6A4F),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Гость',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Нет активной подписки',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D6A4F),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Войти / Зарегистрироваться',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _MenuItem(icon: Icons.stars_outlined, title: 'Моя подписка'),
          _MenuItem(icon: Icons.bookmark_outline, title: 'Сохранённые'),
          _MenuItem(icon: Icons.shopping_bag_outlined, title: 'Мои покупки'),
          _MenuItem(icon: Icons.notifications_outlined, title: 'Уведомления'),
          _MenuItem(icon: Icons.settings_outlined, title: 'Настройки'),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const _MenuItem({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF2D6A4F)),
        title: Text(
          title,
          style: GoogleFonts.inter(fontSize: 15, color: const Color(0xFF1A1A1A)),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: Color(0xFF999999),
        ),
        onTap: () {},
      ),
    );
  }
}
