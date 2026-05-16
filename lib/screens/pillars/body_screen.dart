import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../widgets/pillar_section_card.dart';
import '../../widgets/book_card.dart';
import '../../data/books.dart';
import '../nutrition/nutrition_screen.dart';
import '../lessons_screen.dart';
import '../practices/breathing_478_screen.dart';

class BodyScreen extends StatelessWidget {
  const BodyScreen({super.key});

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
          PillarSectionCard(
            icon: LucideIcons.utensils,
            title: 'Питание',
            subtitle: 'Калории, белки, жиры, углеводы',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NutritionScreen()),
            ),
          ),
          const SizedBox(height: 10),
          PillarSectionCard(
            icon: LucideIcons.activity,
            title: 'Движение',
            subtitle: 'Йога и привычки',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LessonsScreen()),
            ),
          ),
          const SizedBox(height: 10),
          const PillarSectionCard(
            icon: LucideIcons.moon,
            title: 'Сон',
            subtitle: 'Скоро · вход в Клуб',
            isDimmed: true,
          ),
          const SizedBox(height: 10),
          PillarSectionCard(
            icon: LucideIcons.wind,
            title: 'Дыхание',
            subtitle: 'Практика 4-7-8',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const Breathing478Screen()),
            ),
          ),
          const SizedBox(height: YgeiaSpacing.xl),
          BookCard(book: kBooks.firstWhere((b) => b.pillar == 'body')),
        ],
      ),
      ),
    );
  }
}
