import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../widgets/coming_soon_section.dart';
import '../../widgets/book_card.dart';
import '../../data/books.dart';
import '../../config/feature_flags.dart';

class LifeScreen extends StatelessWidget {
  const LifeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YgeiaColors.bgBase,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: YgeiaSpacing.lg),
            const Expanded(
              child: ComingSoonSection(
                pillarName: 'Жизнь',
                pillarIcon: LucideIcons.users,
                upcoming: [
                  'Цифровая гигиена',
                  'Связи и общение',
                  'Среда обитания',
                ],
              ),
            ),
            if (FeatureFlags.kBooksEnabled) ...[
              const SizedBox(height: YgeiaSpacing.xl),
              BookCard(book: kBooks.firstWhere((b) => b.pillar == 'life')),
            ],
            const SizedBox(height: YgeiaSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
