import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  static final FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: _analytics);

  static Future<void> logMoodSaved(int level) async {
    await _analytics.logEvent(
      name: 'mood_saved',
      parameters: {'level': level},
    );
  }

  static Future<void> logEmotionWheelUsed(String emotion) async {
    await _analytics.logEvent(
      name: 'emotion_wheel_used',
      parameters: {'emotion': emotion},
    );
  }

  static Future<void> logBreathingStarted() async {
    await _analytics.logEvent(name: 'breathing_started');
  }

  static Future<void> logJournalEntryAdded() async {
    await _analytics.logEvent(name: 'journal_entry_added');
  }

  static const List<String> _pillarNames = [
    'today',
    'body',
    'mind',
    'emotions',
    'meaning',
    'life',
  ];

  static Future<void> logPillarView(int index) async {
    final name = _pillarNames[index];
    await _analytics.logScreenView(screenName: name);
  }

  static Future<void> logRitualStepCompleted({
    required String ritualId,
    required String stepId,
  }) async {
    await _analytics.logEvent(
      name: 'ritual_step_completed',
      parameters: {
        'ritual': ritualId,
        'step': stepId,
      },
    );
  }
}
