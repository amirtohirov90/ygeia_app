import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/journal_entry.dart';

class JournalService {
  static final _db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _db.collection('users').doc(uid).collection('journal');

  Future<void> addEntry(String text) async {
    final now = DateTime.now();
    final id = now.millisecondsSinceEpoch.toString();
    final entry = JournalEntry(id: id, text: text.trim(), createdAt: now);
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      await _col(uid).doc(id).set(entry.toMap());
    } else {
      await _addToPrefs(entry);
    }
  }

  Stream<List<JournalEntry>> getRecentEntries({int limit = 30}) {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      return _col(uid)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .snapshots()
          .map((s) =>
              s.docs.map((d) => JournalEntry.fromMap(d.data())).toList());
    } else {
      return _prefsStream(limit);
    }
  }

  Future<void> deleteEntry(String id) async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      await _col(uid).doc(id).delete();
    } else {
      final list = await _loadFromPrefs();
      list.removeWhere((e) => e.id == id);
      await _saveListToPrefs(list);
    }
  }

  Future<void> _addToPrefs(JournalEntry entry) async {
    final list = await _loadFromPrefs();
    list.insert(0, entry);
    if (list.length > 50) list.removeRange(50, list.length);
    await _saveListToPrefs(list);
  }

  Future<List<JournalEntry>> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('journal_entries');
    if (raw == null) return [];
    final decoded = json.decode(raw) as List<dynamic>;
    return decoded
        .map((e) => JournalEntry.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _saveListToPrefs(List<JournalEntry> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'journal_entries',
      json.encode(list.map((e) => e.toMap()).toList()),
    );
  }

  Stream<List<JournalEntry>> _prefsStream(int limit) async* {
    final list = await _loadFromPrefs();
    yield list.take(limit).toList();
  }
}
