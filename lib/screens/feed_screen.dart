import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post.dart';
import '../services/firestore_service.dart';
import '../widgets/highlighted_text.dart';
import 'post_detail_screen.dart';
import 'search_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final FirestoreService _service = FirestoreService();
  bool _showFavorites = false;
  Set<String> _favoriteIds = {};

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteIds = (prefs.getStringList('favorite_posts') ?? []).toSet();
    });
  }

  List<Post> _filter(List<Post> posts) {
    if (_showFavorites) {
      return posts.where((p) => _favoriteIds.contains(p.id)).toList();
    }
    return posts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0E8DA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D6A4F),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: SizedBox(
            width: 26,
            height: 26,
            child: CustomPaint(painter: _LeafPainter()),
          ),
        ),
        title: Text(
          'ygeia',
          style: GoogleFonts.playfairDisplay(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchScreen()),
            ),
          ),
          IconButton(
            icon: Icon(
              _showFavorites ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.white,
            ),
            onPressed: () {
              _loadFavorites();
              setState(() => _showFavorites = !_showFavorites);
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Post>>(
        stream: _service.getPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2D6A4F)),
            );
          }

          final allPosts = (snapshot.hasData && snapshot.data!.isNotEmpty)
              ? snapshot.data!
              : _staticPosts.map((m) => Post.fromMap(m)).toList();

          final posts = _filter(allPosts);

          if (posts.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _showFavorites ? Icons.bookmark_border : Icons.article_outlined,
                    size: 56,
                    color: const Color(0xFFCCCCCC),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _showFavorites ? 'Нет сохранённых постов' : 'Нет публикаций',
                    style: GoogleFonts.inter(
                        fontSize: 15, color: const Color(0xFF999999)),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: const Color(0xFF2D6A4F),
            onRefresh: () async => _loadFavorites(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: posts.length,
              itemBuilder: (context, index) => PostCard(
                post: posts[index],
                query: '',
                onFavoriteChanged: _loadFavorites,
              ),
            ),
          );
        },
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final Post post;
  final String query;
  final VoidCallback? onFavoriteChanged;

  const PostCard(
      {super.key, required this.post, required this.query, this.onFavoriteChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, animation, __) => PostDetailScreen(post: post),
            transitionsBuilder: (_, animation, __, child) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                        begin: const Offset(0, 0.04), end: Offset.zero)
                    .animate(CurvedAnimation(
                        parent: animation, curve: Curves.easeOut)),
                child: child,
              ),
            ),
          ),
        ).then((_) => onFavoriteChanged?.call());
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFFAF4EC),
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
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: post.imageUrl != null && post.imageUrl!.isNotEmpty
                  ? Image.network(
                      post.imageUrl!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) =>
                          progress == null
                              ? child
                              : Container(
                                  height: 200,
                                  color: const Color(0xFF2D6A4F)
                                      .withOpacity(0.08),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                        color: Color(0xFF2D6A4F),
                                        strokeWidth: 2),
                                  ),
                                ),
                      errorBuilder: (_, __, ___) => _placeholderImage(),
                    )
                  : _placeholderImage(),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (post.category.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D6A4F).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        post.category,
                        style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2D6A4F)),
                      ),
                    ),
                  HighlightedText(
                    text: post.title,
                    query: query,
                    baseStyle: GoogleFonts.playfairDisplay(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A1A1A)),
                  ),
                  const SizedBox(height: 8),
                  HighlightedText(
                    text: post.body,
                    query: query,
                    baseStyle: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF666666),
                        height: 1.6),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(post.date,
                          style: GoogleFonts.inter(
                              fontSize: 12, color: const Color(0xFF999999))),
                      Row(
                        children: [
                          const Icon(Icons.favorite_border,
                              size: 15, color: Color(0xFF999999)),
                          if (post.likes > 0) ...[
                            const SizedBox(width: 4),
                            Text('${post.likes}',
                                style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: const Color(0xFF999999))),
                          ],
                          const SizedBox(width: 12),
                          Text('Читать →',
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: const Color(0xFF2D6A4F),
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _placeholderImage() {
  return Container(
    height: 200,
    width: double.infinity,
    color: const Color(0xFF2D6A4F).withOpacity(0.08),
    child:
        const Icon(Icons.eco_outlined, size: 60, color: Color(0xFF2D6A4F)),
  );
}

// ── Кастомный лист ───────────────────────────────────────────────────────────
class _LeafPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Форма листа — миндалевидная, чуть наклонённая
    final leaf = Path();
    leaf.moveTo(w * 0.50, h * 0.98); // нижний кончик (стебель)
    leaf.cubicTo(
      w * -0.05, h * 0.75,
      w * -0.05, h * 0.20,
      w * 0.50, h * 0.02, // верхний кончик
    );
    leaf.cubicTo(
      w * 1.05, h * 0.20,
      w * 1.05, h * 0.75,
      w * 0.50, h * 0.98,
    );
    leaf.close();
    canvas.drawPath(leaf, fillPaint);

    // Центральная жилка
    final veinPaint = Paint()
      ..color = const Color(0xFF2D6A4F).withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.07
      ..strokeCap = StrokeCap.round;

    final vein = Path();
    vein.moveTo(w * 0.50, h * 0.95);
    vein.quadraticBezierTo(w * 0.50, h * 0.50, w * 0.50, h * 0.05);
    canvas.drawPath(vein, veinPaint);
  }

  @override
  bool shouldRepaint(_LeafPainter old) => false;
}

const List<Map<String, String>> _staticPosts = [
  {
    'title': 'Утренняя йога: 5 асан для начала дня',
    'body': 'Начни утро с этих простых асан — они разбудят тело и настроят ум на продуктивный день. Всего 15 минут изменят твоё утро.',
    'date': '9 мая 2026',
    'category': 'Йога',
  },
  {
    'title': 'Почему сахар по утрам — это плохая идея',
    'body': 'Резкий скачок глюкозы утром запускает цикл усталости и тяги к сладкому. Рассказываем что есть вместо этого.',
    'date': '8 мая 2026',
    'category': 'Питание',
  },
  {
    'title': '3 привычки для здоровья без усилий',
    'body': 'Микро-привычки работают лучше жёстких систем. Вот три изменения, которые не потребуют силы воли.',
    'date': '7 мая 2026',
    'category': 'Привычки',
  },
  {
    'title': 'Как питаться, чтобы было больше энергии',
    'body': 'Усталость после обеда — не норма. Разбираем что и когда есть, чтобы оставаться в ресурсе весь день.',
    'date': '6 мая 2026',
    'category': 'Питание',
  },
];
