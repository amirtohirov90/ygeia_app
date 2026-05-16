import '../data/insights.dart';

class DailyInsightService {
  static Insight todaysInsight() {
    final dayIndex =
        DateTime.now().millisecondsSinceEpoch ~/ (1000 * 60 * 60 * 24);
    return kInsights[dayIndex % kInsights.length];
  }
}
