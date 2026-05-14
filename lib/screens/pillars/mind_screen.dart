import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../widgets/pillar_section_card.dart';

class MindScreen extends StatelessWidget {
  const MindScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).textTheme.headlineLarge!;
    final italic = GoogleFonts.fraunces(
      fontSize: base.fontSize,
      fontWeight: base.fontWeight,
      color: base.color,
      fontStyle: FontStyle.italic,
    );

    return Scaffold(
      backgroundColor: YgeiaColors.bgBase,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text.rich(
          TextSpan(
            style: base,
            children: [
              TextSpan(text: 'У', style: italic),
              const TextSpan(text: 'м'),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: YgeiaSpacing.md,
          vertical: YgeiaSpacing.md,
        ),
        children: const [
          PillarSectionCard(
            icon: LucideIcons.brain,
            title: 'Медитация',
            subtitle: 'Скоро · вход в Клуб',
            isDimmed: true,
          ),
          SizedBox(height: 10),
          PillarSectionCard(
            icon: LucideIcons.target,
            title: 'Фокус',
            subtitle: 'Скоро · техники концентрации',
            isDimmed: true,
          ),
          SizedBox(height: 10),
          PillarSectionCard(
            icon: LucideIcons.zap,
            title: 'Стресс',
            subtitle: 'Скоро · работа с напряжением',
            isDimmed: true,
          ),
        ],
      ),
    );
  }
}
