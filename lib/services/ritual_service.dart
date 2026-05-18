import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RitualService {
  static final _db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static String _todayId() {
    final d = DateTime.now();
    return '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }

  static DocumentReference<Map<String, dynamic>> _doc(String uid) => _db
      .collection('users')
      .doc(uid)
      .collection('ritual_progress')
      .doc(_todayId());

  static String _prefsKey() => 'ritual_progress_${_todayId()}';

  Stream<Map<String, Set<String>>> watchTodayProgress() {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      return _doc(uid).snapshots().map((snap) => _parseDoc(
            snap.exists ? snap.data()! : {},
          ));
    } else {
      return _prefsStream();
    }
  }

  Future<void> toggleStep(String ritualId, String stepId) async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      await _toggleFirestore(uid, ritualId, stepId);
    } else {
      await _togglePrefs(ritualId, stepId);
    }
  }

  // ── Firebase ──────────────────────────────────────────────────────────────

  Future<void> _toggleFirestore(
      String uid, String ritualId, String stepId) async {
    final snap = await _doc(uid).get();
    final data = snap.exists
        ? Map<String, dynamic>.from(snap.data()!)
        : <String, dynamic>{};
    final steps = List<String>.from(
        (data[ritualId] as List<dynamic>? ?? []).cast<String>());
    if (steps.contains(stepId)) {
      steps.remove(stepId);
    } else {
      steps.add(stepId);
    }
    data[ritualId] = steps;
    await _doc(uid).set(data);
  }

  // ── SharedPreferences ─────────────────────────────────────────────────────

  Future<Map<String, Set<String>>> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey());
    if (raw == null) return {'morning': {}, 'evening': {}, 'digital': {}};
    return _parseDoc(json.decode(raw) as Map<String, dynamic>);
  }

  Future<void> _savePrefs(Map<String, Set<String>> progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _prefsKey(),
      json.encode({
        'morning': progress['morning']!.toList(),
        'evening': progress['evening']!.toList(),
        'digital': (progress['digital'] ?? <String>{}).toList(),
      }),
    );
  }

  Future<void> _togglePrefs(String ritualId, String stepId) async {
    final progress = await _loadPrefs();
    final steps = progress[ritualId] ?? {};
    if (steps.contains(stepId)) {
      steps.remove(stepId);
    } else {
      steps.add(stepId);
    }
    progress[ritualId] = steps;
    await _savePrefs(progress);
  }

  Stream<Map<String, Set<String>>> _prefsStream() async* {
    yield await _loadPrefs();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  static Map<String, Set<String>> _parseDoc(Map<String, dynamic> data) => {
        'morning': Set<String>.from(
            (data['morning'] as List<dynamic>? ?? []).cast<String>()),
        'evening': Set<String>.from(
            (data['evening'] as List<dynamic>? ?? []).cast<String>()),
        'digital': Set<String>.from(
            (data['digital'] as List<dynamic>? ?? []).cast<String>()),
      };
}
