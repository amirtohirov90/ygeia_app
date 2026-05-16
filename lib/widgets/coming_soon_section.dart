import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';

class ComingSoonSection extends StatelessWidget {
  final String pillarName;
  final IconData pillarIcon;
  final List<String> upcoming;

  const ComingSoonSection({
    super.key,
    required this.pillarName,
    required this.pillarIcon,
    required this.upcoming,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(pillarIcon, size: 48, color: YgeiaColors.textMuted),
            const SizedBox(height: 20),
            Text(
              'Раздел $pillarName появится скоро',
              textAlign: TextAlign.center,
              style: GoogleFonts.fraunces(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: YgeiaColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'В Фазе 3 здесь будет:',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: YgeiaColors.textSecondary,
              ),
            ),
            const SizedBox(height: 10),
            ...upcoming.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: YgeiaColors.textMuted,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: YgeiaColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
