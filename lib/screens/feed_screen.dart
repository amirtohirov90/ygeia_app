import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _posts.length,
        itemBuilder: (context, index) => PostCard(post: _posts[index]),
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final Map<String, String> post;
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
              height: 200,
              width: double.infinity,
              color: const Color(0xFF2D6A4F).withOpacity(0.1),
              child: const Icon(
                Icons.eco_outlined,
                size: 64,
                color: Color(0xFF2D6A4F),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post['title']!,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  post['body']!,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF666666),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  post['date']!,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const List<Map<String, String>> _posts = [
  {
    'title': 'Утренняя йога: 5 асан для начала дня',
    'body':
        'Начни утро с этих простых асан — они разбудят тело и настроят ум на продуктивный день. Всего 15 минут изменят твоё утро.',
    'date': '9 мая 2026',
  },
  {
    'title': 'Почему сахар по утрам — это плохая идея',
    'body':
        'Резкий скачок глюкозы утром запускает цикл усталости и тяги к сладкому. Рассказываем что есть вместо этого.',
    'date': '8 мая 2026',
  },
  {
    'title': '3 привычки для здоровья без усилий',
    'body':
        'Микро-привычки работают лучше жёстких систем. Вот три изменения, которые не потребуют силы воли.',
    'date': '7 мая 2026',
  },
  {
    'title': 'Как питаться, чтобы было больше энергии',
    'body':
        'Усталость после обеда — не норма. Разбираем что и когда есть, чтобы оставаться в ресурсе весь день.',
    'date': '6 мая 2026',
  },
];
