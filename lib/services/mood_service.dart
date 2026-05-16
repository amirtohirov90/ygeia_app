import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/mood_entry.dart';

class MoodService {
  static final _db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static String _dateId(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  static CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _db.collection('users').doc(uid).collection('mood_entries');

  Future<void> saveMoodToday(int level, String? note) async {
    final now = DateTime.now();
    final id = _dateId(now);
    final trimmed = note?.trim();
    final entry = MoodEntry(
      id: id,
      date: now,
      level: level,
      note: (trimmed == null || trimmed.isEmpty) ? null : trimmed,
      createdAt: now,
    );
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      await _col(uid).doc(id).set(entry.toMap());
    } else {
      await _saveToPrefs(entry);
    }
  }

  Future<MoodEntry?> getMoodToday() async {
    final id = _dateId(DateTime.now());
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      final doc = await _col(uid).doc(id).get();
      if (!doc.exists) return null;
      return MoodEntry.fromMap(doc.data()!);
    } else {
      final list = await _loadFromPrefs();
      try {
        return list.firstWhere((e) => e.id == id);
      } catch (_) {
        return null;
      }
    }
  }

  Stream<List<MoodEntry>> getRecentMoods({int days = 14}) {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      final cutoff = DateTime.now().subtract(Duration(days: days));
      return _col(uid)
          .where('date', isGreaterThanOrEqualTo: cutoff.toIso8601String())
          .orderBy('date', descending: true)
          .snapshots()
          .map((s) => s.docs.map((d) => MoodEntry.fromMap(d.data())).toList());
    } else {
      return _prefsStream(days);
    }
  }

  Future<void> deleteToday() async {
    final id = _dateId(DateTime.now());
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      await _col(uid).doc(id).delete();
    } else {
      final list = await _loadFromPrefs();
      list.removeWhere((e) => e.id == id);
      await _saveListToPrefs(list);
    }
  }

  Future<void> _saveToPrefs(MoodEntry entry) async {
    final list = await _loadFromPrefs();
    list.removeWhere((e) => e.id == entry.id);
    list.insert(0, entry);
    if (list.length > 30) list.removeRange(30, list.length);
    await _saveListToPrefs(list);
  }

  Future<List<MoodEntry>> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('mood_entries');
    if (raw == null) return [];
    final decoded = json.decode(raw) as List<dynamic>;
    return decoded
        .map((e) => MoodEntry.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _saveListToPrefs(List<MoodEntry> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'mood_entries',
      json.encode(list.map((e) => e.toMap()).toList()),
    );
  }

  Stream<List<MoodEntry>> _prefsStream(int days) async* {
    final list = await _loadFromPrefs();
    final cutoff = DateTime.now().subtract(Duration(days: days));
    yield list.where((e) => e.date.isAfter(cutoff)).toList();
  }
}
