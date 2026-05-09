import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

// Замени на свои реальные ссылки для оплаты
const _monthlyUrl = 'https://t.me/ygeia'; // ссылка на оплату месяца
const _yearlyUrl = 'https://t.me/ygeia';  // ссылка на оплату года

class ClubScreen extends StatefulWidget {
  const ClubScreen({super.key});

  @override
  State<ClubScreen> createState() => _ClubScreenState();
}

class _ClubScreenState extends State<ClubScreen> {
  bool _yearSelected = true;

  Future<void> _openPayment() async {
    final url = Uri.parse(_yearSelected ? _yearlyUrl : _monthlyUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось открыть ссылку')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D6A4F),
        title: Text(
          'Клуб',
          style: GoogleFonts.playfairDisplay(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: const Color(0xFF2D6A4F).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.stars,
                size: 44,
                color: Color(0xFF2D6A4F),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Закрытый клуб ygeia',
              style: GoogleFonts.playfairDisplay(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A1A1A),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Эксклюзивный контент, живые встречи, сообщество единомышленниц и персональная поддержка.',
              style: GoogleFonts.inter(
                fontSize: 15,
                color: const Color(0xFF666666),
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _FeatureRow(icon: Icons.lock_open_outlined, text: 'Закрытые уроки и материалы'),
            const SizedBox(height: 12),
            _FeatureRow(icon: Icons.people_outline, text: 'Сообщество единомышленниц'),
            const SizedBox(height: 12),
            _FeatureRow(icon: Icons.live_tv_outlined, text: 'Живые эфиры каждую неделю'),
            const SizedBox(height: 12),
            _FeatureRow(icon: Icons.chat_bubble_outline, text: 'Личная поддержка'),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () => setState(() => _yearSelected = false),
              child: _PlanCard(
                title: 'Месяц',
                price: '490 ₽',
                period: 'в месяц',
                isHighlighted: !_yearSelected,
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => setState(() => _yearSelected = true),
              child: _PlanCard(
                title: 'Год',
                price: '3 900 ₽',
                period: 'в год • экономия 30%',
                isHighlighted: _yearSelected,
                badge: 'Лучший выбор',
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _openPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D6A4F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Вступить в клуб',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Безопасная оплата. Отменить можно в любой момент.',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF999999),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF2D6A4F), size: 22),
        const SizedBox(width: 12),
        Text(
          text,
          style: GoogleFonts.inter(fontSize: 15, color: const Color(0xFF333333)),
        ),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String period;
  final bool isHighlighted;
  final String? badge;

  const _PlanCard({
    required this.title,
    required this.price,
    required this.period,
    this.isHighlighted = false,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isHighlighted ? const Color(0xFF2D6A4F) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF2D6A4F),
              width: isHighlighted ? 0 : 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isHighlighted ? Colors.white : const Color(0xFF1A1A1A),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isHighlighted ? Colors.white : const Color(0xFF2D6A4F),
                    ),
                  ),
                  Text(
                    period,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: isHighlighted ? Colors.white70 : const Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (badge != null)
          Positioned(
            top: -1,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE07A5F),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                badge!,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
