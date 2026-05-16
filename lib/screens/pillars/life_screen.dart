import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../widgets/coming_soon_section.dart';

class LifeScreen extends StatelessWidget {
  const LifeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YgeiaColors.bgBase,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: YgeiaSpacing.lg),
          child: const ComingSoonSection(
            pillarName: 'Жизнь',
            pillarIcon: LucideIcons.users,
            upcoming: [
              'Цифровая гигиена',
              'Связи и общение',
              'Среда обитания',
            ],
          ),
        ),
      ),
    );
  }
}
