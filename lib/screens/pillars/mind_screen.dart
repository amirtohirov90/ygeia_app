import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../widgets/pillar_section_card.dart';
import '../../widgets/book_card.dart';
import '../../data/books.dart';

class MindScreen extends StatelessWidget {
  const MindScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YgeiaColors.bgBase,
      body: SafeArea(
        child: ListView(
        padding: const EdgeInsets.only(
          left: YgeiaSpacing.md,
          right: YgeiaSpacing.md,
          top: YgeiaSpacing.lg,
          bottom: YgeiaSpacing.md,
        ),
        children: [
          const PillarSectionCard(
            icon: LucideIcons.brain,
            title: 'Медитация',
            subtitle: 'Скоро · вход в Клуб',
            isDimmed: true,
          ),
          const SizedBox(height: 10),
          const PillarSectionCard(
            icon: LucideIcons.target,
            title: 'Фокус',
            subtitle: 'Скоро · техники концентрации',
            isDimmed: true,
          ),
          const SizedBox(height: 10),
          const PillarSectionCard(
            icon: LucideIcons.zap,
            title: 'Стресс',
            subtitle: 'Скоро · работа с напряжением',
            isDimmed: true,
          ),
          const SizedBox(height: YgeiaSpacing.xl),
          BookCard(book: kBooks.firstWhere((b) => b.pillar == 'mind')),
        ],
      ),
      ),
    );
  }
}
