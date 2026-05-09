import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/english_content.dart';
import '../models/english_models.dart';

class LessonProgress {
  final int stars; // 0 = not done, 1-3 = completed with stars
  final bool completed;

  const LessonProgress({required this.stars, required this.completed});

  Map<String, dynamic> toMap() => {'stars': stars, 'completed': completed};

  factory LessonProgress.fromMap(Map<String, dynamic> m) =>
      LessonProgress(stars: m['stars'] ?? 0, completed: m['completed'] ?? false);
}

class EnglishProgress {
  final Map<String, LessonProgress> lessons; // lessonId → progress
  final int totalXp;
  final int currentStreak;
  final String? lastStudiedDate; // 'YYYY-MM-DD'

  const EnglishProgress({
    required this.lessons,
    required this.totalXp,
    required this.currentStreak,
    this.lastStudiedDate,
  });

  factory EnglishProgress.empty() => const EnglishProgress(
        lessons: {},
        totalXp: 0,
        currentStreak: 0,
      );

  Map<String, dynamic> toMap() => {
        'lessons': lessons.map((k, v) => MapEntry(k, v.toMap())),
        'totalXp': totalXp,
        'currentStreak': currentStreak,
        'lastStudiedDate': lastStudiedDate,
      };

  factory EnglishProgress.fromMap(Map<String, dynamic> m) {
    final lessonsRaw = m['lessons'] as Map<String, dynamic>? ?? {};
    return EnglishProgress(
      lessons: lessonsRaw.map(
          (k, v) => MapEntry(k, LessonProgress.fromMap(v as Map<String, dynamic>))),
      totalXp: m['totalXp'] ?? 0,
      currentStreak: m['currentStreak'] ?? 0,
      lastStudiedDate: m['lastStudiedDate'],
    );
  }
}

class EnglishService {
  static const _key = 'english_progress';

  Future<EnglishProgress> getProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_key);
    if (json == null) return EnglishProgress.empty();
    try {
      return EnglishProgress.fromMap(jsonDecode(json) as Map<String, dynamic>);
    } catch (_) {
      return EnglishProgress.empty();
    }
  }

  Future<EnglishProgress> completeLesson(
      String lessonId, int mistakes) async {
    final progress = await getProgress();

    // Calculate stars: 0-1 mistakes → 3, 2-3 → 2, 4+ → 1
    final int stars = mistakes <= 1
        ? 3
        : mistakes <= 3
            ? 2
            : 1;

    // XP: 15 / 10 / 5
    final int xp = stars == 3 ? 15 : stars == 2 ? 10 : 5;

    // Only give XP if improving star count
    final existing = progress.lessons[lessonId];
    final int extraXp =
        (existing == null || stars > existing.stars) ? xp : 0;

    // Streak logic
    final today = _todayStr();
    int streak = progress.currentStreak;
    if (progress.lastStudiedDate != today) {
      if (progress.lastStudiedDate == _yesterdayStr()) {
        streak++;
      } else if (progress.lastStudiedDate != today) {
        streak = 1;
      }
    }

    final newLessons = Map<String, LessonProgress>.from(progress.lessons);
    newLessons[lessonId] = LessonProgress(
      stars: existing == null ? stars : (stars > existing.stars ? stars : existing.stars),
      completed: true,
    );

    final newProgress = EnglishProgress(
      lessons: newLessons,
      totalXp: progress.totalXp + extraXp,
      currentStreak: streak,
      lastStudiedDate: today,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(newProgress.toMap()));
    return newProgress;
  }

  /// Returns whether a lesson is unlocked based on previous lesson completion.
  bool isLessonUnlocked(String lessonId, EnglishProgress progress) {
    // Find the lesson's position in the course.
    int unitIndex = 0;
    int lessonIndex = 0;
    bool found = false;

    for (int u = 0; u < englishUnits.length; u++) {
      for (int l = 0; l < englishUnits[u].lessons.length; l++) {
        if (englishUnits[u].lessons[l].id == lessonId) {
          unitIndex = u;
          lessonIndex = l;
          found = true;
          break;
        }
      }
      if (found) break;
    }

    if (!found) return false;

    // First lesson of first unit is always unlocked.
    if (unitIndex == 0 && lessonIndex == 0) return true;

    // Otherwise unlock if the previous lesson is completed.
    String prevLessonId;
    if (lessonIndex > 0) {
      prevLessonId = englishUnits[unitIndex].lessons[lessonIndex - 1].id;
    } else {
      // First lesson of unit → need last lesson of previous unit.
      prevLessonId = englishUnits[unitIndex - 1].lessons.last.id;
    }

    return progress.lessons[prevLessonId]?.completed == true;
  }

  String _todayStr() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  String _yesterdayStr() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';
  }
}
