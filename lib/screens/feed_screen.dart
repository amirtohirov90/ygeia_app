import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post.dart';
import '../services/firestore_service.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = FirestoreService();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D6A4F),
        title: Text(
          'ygeia',
          style: GoogleFonts.playfairDisplay(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: StreamBuilder<List<Post>>(
        stream: service.getPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2D6A4F)),
            );
          }

          final posts = (snapshot.hasData && snapshot.data!.isNotEmpty)
              ? snapshot.data!
              : _staticPosts.map((m) => Post.fromMap(m)).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: posts.length,
            itemBuilder: (context, index) => PostCard(post: posts[index]),
          );
        },
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              height: 180,
              width: double.infinity,
              color: const Color(0xFF2D6A4F).withOpacity(0.1),
              child: const Icon(
                Icons.eco_outlined,
                size: 60,
                color: Color(0xFF2D6A4F),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (post.category.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D6A4F).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      post.category,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2D6A4F),
                      ),
                    ),
                  ),
                Text(
                  post.title,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  post.body,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF666666),
                    height: 1.6,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      post.date,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF999999),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.favorite_border,
                            size: 16, color: Color(0xFF999999)),
                        const SizedBox(width: 4),
                        Text(
                          'Нравится',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF999999),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const List<Map<String, String>> _staticPosts = [
  {
    'title': 'Утренняя йога: 5 асан для начала дня',
    'body':
        'Начни утро с этих простых асан — они разбудят тело и настроят ум на продуктивный день. Всего 15 минут изменят твоё утро.',
    'date': '9 мая 2026',
    'category': 'Йога',
  },
  {
    'title': 'Почему сахар по утрам — это плохая идея',
    'body':
        'Резкий скачок глюкозы утром запускает цикл усталости и тяги к сладкому. Рассказываем что есть вместо этого.',
    'date': '8 мая 2026',
    'category': 'Питание',
  },
  {
    'title': '3 привычки для здоровья без усилий',
    'body':
        'Микро-привычки работают лучше жёстких систем. Вот три изменения, которые не потребуют силы воли.',
    'date': '7 мая 2026',
    'category': 'Привычки',
  },
  {
    'title': 'Как питаться, чтобы было больше энергии',
    'body':
        'Усталость после обеда — не норма. Разбираем что и когда есть, чтобы оставаться в ресурсе весь день.',
    'date': '6 мая 2026',
    'category': 'Питание',
  },
];
