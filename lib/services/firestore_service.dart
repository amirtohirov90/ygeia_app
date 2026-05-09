import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/post.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ── Posts ──────────────────────────────────────────
  Stream<List<Post>> getPosts() {
    return _db
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => Post.fromFirestore(doc)).toList());
  }

  // ── Likes ──────────────────────────────────────────
  Future<void> toggleLike(String postId, bool currentlyLiked) async {
    final user = _auth.currentUser;
    final ref = _db.collection('posts').doc(postId);
    final email = user?.email ?? 'anonymous';

    if (currentlyLiked) {
      await ref.update({
        'likes': FieldValue.increment(-1),
        'likedByEmails': FieldValue.arrayRemove([email]),
      });
    } else {
      await ref.update({
        'likes': FieldValue.increment(1),
        'likedByEmails': FieldValue.arrayUnion([email]),
      });
    }
  }

  // ── Comments ───────────────────────────────────────
  Stream<List<Comment>> getComments(String postId) {
    return _db
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => Comment.fromFirestore(doc)).toList());
  }

  Future<void> addComment(String postId, String text) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _db
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add({
      'text': text,
      'userId': user.uid,
      'userEmail': user.email ?? '',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteComment(String postId, String commentId) async {
    await _db
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .delete();
  }
}

class Comment {
  final String id;
  final String text;
  final String userId;
  final String userEmail;
  final DateTime? createdAt;

  Comment({
    required this.id,
    required this.text,
    required this.userId,
    required this.userEmail,
    this.createdAt,
  });

  factory Comment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Comment(
      id: doc.id,
      text: data['text'] ?? '',
      userId: data['userId'] ?? '',
      userEmail: data['userEmail'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  String get displayName {
    if (userEmail.isEmpty) return 'Гость';
    final name = userEmail.split('@').first;
    return name[0].toUpperCase() + name.substring(1);
  }

  String get initials {
    final name = displayName;
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}
