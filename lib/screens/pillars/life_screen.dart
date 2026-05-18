import 'package:flutter/material.dart';
import '../../config/feature_flags.dart';
import '../../data/books.dart';
import '../../data/rituals.dart';
import '../../services/ritual_service.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../widgets/book_card.dart';
import '../../widgets/ritual_card.dart';

class LifeScreen extends StatefulWidget {
  const LifeScreen({super.key});

  @override
  State<LifeScreen> createState() => _LifeScreenState();
}

class _LifeScreenState extends State<LifeScreen> {
  final _ritualService = RitualService();
  int _progressRefresh = 0;

  Future<void> _toggleStep(String ritualId, String stepId) async {
    await _ritualService.toggleStep(ritualId, stepId);
    if (mounted) setState(() => _progressRefresh++);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YgeiaColors.bgBase,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(YgeiaSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: YgeiaSpacing.lg),
              StreamBuilder<Map<String, Set<String>>>(
                key: ValueKey(_progressRefresh),
                stream: _ritualService.watchTodayProgress(),
                builder: (context, snapshot) {
                  final progress = snapshot.data ?? {};
                  return RitualCard(
                    ritual: kRituals.firstWhere((r) => r.id == 'digital'),
                    completedStepIds: progress['digital'] ?? const <String>{},
                    onToggleStep: (stepId) => _toggleStep('digital', stepId),
                  );
                },
              ),
              const SizedBox(height: YgeiaSpacing.xl),
              const Center(
                child: Text(
                  'Скоро · связи, среда обитания',
                  style: TextStyle(
                    color: YgeiaColors.textMuted,
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: YgeiaSpacing.lg),
              if (FeatureFlags.kBooksEnabled) ...[
                BookCard(book: kBooks.firstWhere((b) => b.pillar == 'life')),
                const SizedBox(height: YgeiaSpacing.lg),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
