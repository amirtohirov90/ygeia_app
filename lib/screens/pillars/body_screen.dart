import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';

class BodyScreen extends StatelessWidget {
  const BodyScreen({super.key});

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
              const TextSpan(text: 'Те'),
              TextSpan(text: 'ло', style: italic),
            ],
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(YgeiaSpacing.lg),
          child: Text(
            'Скоро здесь будет... Тело',
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
