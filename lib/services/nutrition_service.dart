import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/nutrition_profile.dart';
import '../models/food_item.dart';

class NutritionService {
  static const _profileKey = 'nutrition_profile';
  static const _logsPrefix = 'meal_log_';
  static const _waterPrefix = 'water_';

  // ── Profile ─────────────────────────────────────────
  Future<NutritionProfile?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_profileKey);
    if (json == null) return null;
    return NutritionProfile.fromJson(json);
  }

  Future<void> saveProfile(NutritionProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, profile.toJson());
  }

  // ── Meal Logs ────────────────────────────────────────
  String _dateKey(DateTime date) =>
      '$_logsPrefix${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Future<List<MealEntry>> getEntries(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_dateKey(date));
    if (json == null) return [];
    final list = jsonDecode(json) as List;
    return list.map((m) => MealEntry.fromMap(m)).toList();
  }

  Future<void> addEntry(MealEntry entry, DateTime date) async {
    final entries = await getEntries(date);
    entries.add(entry);
    await _saveEntries(entries, date);
  }

  Future<void> deleteEntry(String entryId, DateTime date) async {
    final entries = await getEntries(date);
    entries.removeWhere((e) => e.id == entryId);
    await _saveEntries(entries, date);
  }

  Future<void> _saveEntries(List<MealEntry> entries, DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _dateKey(date),
      jsonEncode(entries.map((e) => e.toMap()).toList()),
    );
  }

  // ── Water ────────────────────────────────────────────
  String _waterKey(DateTime date) =>
      '$_waterPrefix${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Future<int> getWaterGlasses(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_waterKey(date)) ?? 0;
  }

  Future<void> setWaterGlasses(int glasses, DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_waterKey(date), glasses.clamp(0, 20));
  }

  // ── Summary ──────────────────────────────────────────
  DaySummary calcSummary(List<MealEntry> entries) {
    double cal = 0, p = 0, f = 0, c = 0;
    for (final e in entries) {
      cal += e.calories;
      p += e.protein;
      f += e.fat;
      c += e.carbs;
    }
    return DaySummary(calories: cal, protein: p, fat: f, carbs: c);
  }
}

class DaySummary {
  final double calories;
  final double protein;
  final double fat;
  final double carbs;

  DaySummary({
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
  });
}
