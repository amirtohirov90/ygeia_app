import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../widgets/coming_soon_section.dart';
import '../../widgets/book_card.dart';
import '../../data/books.dart';

class MeaningScreen extends StatelessWidget {
  const MeaningScreen({super.key});

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
                pillarName: 'Смысл',
                pillarIcon: LucideIcons.compass,
                upcoming: [
                  'Утренние ритуалы',
                  'Вечерние ритуалы',
                  'Журнал благодарности',
                ],
              ),
            ),
            const SizedBox(height: YgeiaSpacing.xl),
            BookCard(book: kBooks.firstWhere((b) => b.pillar == 'meaning')),
            const SizedBox(height: YgeiaSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
