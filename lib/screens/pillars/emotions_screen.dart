import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../widgets/coming_soon_section.dart';

class EmotionsScreen extends StatelessWidget {
  const EmotionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YgeiaColors.bgBase,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: YgeiaSpacing.lg),
          child: const ComingSoonSection(
            pillarName: 'Эмоции',
            pillarIcon: LucideIcons.heart,
            upcoming: ['Mood-трекер', 'Журнал мыслей', 'Колесо эмоций'],
          ),
        ),
      ),
    );
  }
}
