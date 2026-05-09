import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String title;
  final String body;
  final String date;
  final String category;
  final String? imageUrl;
  final int likes;
  final DateTime? createdAt;

  Post({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    this.category = '',
    this.imageUrl,
    this.likes = 0,
    this.createdAt,
  });

  factory Post.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Post(
      id: doc.id,
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      date: data['date'] ?? '',
      category: data['category'] ?? '',
      imageUrl: data['imageUrl'],
      likes: (data['likes'] ?? 0) as int,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  factory Post.fromMap(Map<String, String> map) {
    return Post(
      id: map['title'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      date: map['date'] ?? '',
      category: map['category'] ?? '',
      imageUrl: map['imageUrl'],
    );
  }
}
