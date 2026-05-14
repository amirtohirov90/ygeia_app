import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).textTheme.headlineLarge!;

    return Scaffold(
      backgroundColor: YgeiaColors.bgBase,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Доброе утро,',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: YgeiaColors.textSecondary,
              ),
            ),
            Text('Сегодня', style: base),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.user),
            color: YgeiaColors.textPrimary,
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(YgeiaSpacing.lg),
          child: Text(
            'Скоро здесь будет... Сегодня',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: YgeiaColors.textSecondary,
                ),
          ),
        ),
      ),
    );
  }
}
