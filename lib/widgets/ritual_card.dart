import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../data/rituals.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';

class RitualCard extends StatelessWidget {
  final Ritual ritual;
  final Set<String> completedStepIds;
  final ValueChanged<String> onToggleStep;

  const RitualCard({
    super.key,
    required this.ritual,
    required this.completedStepIds,
    required this.onToggleStep,
  });

  @override
  Widget build(BuildContext context) {
    final done = completedStepIds.length;
    final total = ritual.steps.length;

    return Container(
      padding: const EdgeInsets.all(YgeiaSpacing.lg),
      decoration: BoxDecoration(
        color: YgeiaColors.bgCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ritual.title,
            style: GoogleFonts.fraunces(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: YgeiaColors.textPrimary,
            ),
          ),
          const SizedBox(height: YgeiaSpacing.sm),
          Text(
            '$done из $total',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: YgeiaColors.textSecondary,
            ),
          ),
          const SizedBox(height: YgeiaSpacing.md),
          ...ritual.steps.map((step) => _StepRow(
                step: step,
                isCompleted: completedStepIds.contains(step.id),
                onTap: () => onToggleStep(step.id),
              )),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final RitualStep step;
  final bool isCompleted;
  final VoidCallback onTap;

  const _StepRow({
    required this.step,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: YgeiaSpacing.sm,
          horizontal: YgeiaSpacing.xs,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? YgeiaColors.accent : null,
                border: isCompleted
                    ? null
                    : Border.all(
                        color: YgeiaColors.textMuted,
                        width: 1.5,
                      ),
              ),
              child: isCompleted
                  ? const Icon(
                      LucideIcons.check,
                      size: 14,
                      color: YgeiaColors.white,
                    )
                  : null,
            ),
            const SizedBox(width: YgeiaSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.text,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: isCompleted
                          ? YgeiaColors.textPrimary.withValues(alpha: 0.45)
                          : YgeiaColors.textPrimary,
                      decoration:
                          isCompleted ? TextDecoration.lineThrough : null,
                      decorationColor:
                          YgeiaColors.textPrimary.withValues(alpha: 0.45),
                    ),
                  ),
                  if (step.hint != null && !isCompleted) ...[
                    const SizedBox(height: YgeiaSpacing.xs),
                    Text(
                      step.hint!,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: YgeiaColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
