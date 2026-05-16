import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../widgets/coming_soon_section.dart';

class MeaningScreen extends StatelessWidget {
  const MeaningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YgeiaColors.bgBase,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: YgeiaSpacing.lg),
          child: const ComingSoonSection(
            pillarName: 'Смысл',
            pillarIcon: LucideIcons.compass,
            upcoming: [
              'Утренние ритуалы',
              'Вечерние ритуалы',
              'Журнал благодарности',
            ],
          ),
        ),
      ),
    );
  }
}
