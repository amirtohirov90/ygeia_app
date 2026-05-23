import 'package:flutter/material.dart';
import '../../config/feature_flags.dart';
import '../../data/books.dart';
import '../../data/rituals.dart';
import '../../services/ritual_service.dart';
import '../../services/analytics_service.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../widgets/book_card.dart';
import '../../widgets/ritual_card.dart';

class MeaningScreen extends StatefulWidget {
  const MeaningScreen({super.key});

  @override
  State<MeaningScreen> createState() => _MeaningScreenState();
}

class _MeaningScreenState extends State<MeaningScreen> {
  final _ritualService = RitualService();
  int _progressRefresh = 0;

  Future<void> _toggleStep(String ritualId, String stepId) async {
    await _ritualService.toggleStep(ritualId, stepId);
    AnalyticsService.logRitualStepCompleted(ritualId: ritualId, stepId: stepId);
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
                  final morning =
                      progress['morning'] ?? const <String>{};
                  final evening =
                      progress['evening'] ?? const <String>{};
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      RitualCard(
                        ritual: kRituals
                            .firstWhere((r) => r.id == 'morning'),
                        completedStepIds: morning,
                        onToggleStep: (stepId) =>
                            _toggleStep('morning', stepId),
                      ),
                      const SizedBox(height: YgeiaSpacing.lg),
                      RitualCard(
                        ritual: kRituals
                            .firstWhere((r) => r.id == 'evening'),
                        completedStepIds: evening,
                        onToggleStep: (stepId) =>
                            _toggleStep('evening', stepId),
                      ),
                    ],
                  );
                },
              ),
              if (FeatureFlags.kBooksEnabled) ...[
                const SizedBox(height: YgeiaSpacing.xl),
                BookCard(book: kBooks.firstWhere((b) => b.pillar == 'meaning')),
              ],
              const SizedBox(height: YgeiaSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
