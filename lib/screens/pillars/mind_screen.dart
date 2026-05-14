import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(YgeiaSpacing.lg),
          child: Text(
            'Скоро здесь будет... Ум',
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
