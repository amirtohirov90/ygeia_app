import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post.dart';
import '../services/firestore_service.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../widgets/highlighted_text.dart';
import '../screens/post_detail_screen.dart';
import '../screens/search_screen.dart';

class FeedContent extends StatefulWidget {
  const FeedContent({super.key});

  @override
  State<FeedContent> createState() => _FeedContentState();
}

class _FeedContentState extends State<FeedContent> {
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
    if (mounted) {
      setState(() {
        _favoriteIds = (prefs.getStringList('favorite_posts') ?? []).toSet();
      });
    }
  }

  List<Post> _filter(List<Post> posts) {
    if (_showFavorites) {
      return posts.where((p) => _favoriteIds.contains(p.id)).toList();
    }
    return posts;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.search,
                    color: YgeiaColors.textSecondary),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                ),
              ),
              IconButton(
                icon: Icon(
                  _showFavorites ? Icons.bookmark : Icons.bookmark_border,
                  color: _showFavorites
                      ? YgeiaColors.accent
                      : YgeiaColors.textSecondary,
                ),
                onPressed: () {
                  _loadFavorites();
                  setState(() => _showFavorites = !_showFavorites);
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<List<Post>>(
            stream: _service.getPosts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child:
                      CircularProgressIndicator(color: YgeiaColors.accent),
                );
              }

              final allPosts =
                  (snapshot.hasData && snapshot.data!.isNotEmpty)
                      ? snapshot.data!
                      : _staticPosts.map((m) => Post.fromMap(m)).toList();

              final posts = _filter(allPosts);

              if (posts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _showFavorites
                            ? Icons.bookmark_border
                            : Icons.article_outlined,
                        size: 56,
                        color: YgeiaColors.textMuted,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _showFavorites
                            ? 'Нет сохранённых статей'
                            : 'Нет публикаций',
                        style: YgeiaTypography.bodySmall,
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                color: YgeiaColors.accent,
                backgroundColor: YgeiaColors.bgCard,
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
        ),
      ],
    );
  }
}

class PostCard extends StatelessWidget {
  final Post post;
  final String query;
  final VoidCallback? onFavoriteChanged;

  const PostCard({
    super.key,
    required this.post,
    required this.query,
    this.onFavoriteChanged,
  });

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
                  begin: const Offset(0, 0.04),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
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
          color: YgeiaColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
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
                                  color: YgeiaColors.accentSoft,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: YgeiaColors.accent,
                                      strokeWidth: 2,
                                    ),
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
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: YgeiaColors.accentSoft,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        post.category,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: YgeiaColors.accent,
                        ),
                      ),
                    ),
                  HighlightedText(
                    text: post.title,
                    query: query,
                    baseStyle: GoogleFonts.fraunces(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: YgeiaColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  HighlightedText(
                    text: post.body,
                    query: query,
                    baseStyle: YgeiaTypography.bodySmall,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    post.date,
                    style: YgeiaTypography.caption,
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
    color: YgeiaColors.accentSoft,
    child: const Icon(
      Icons.eco_outlined,
      size: 60,
      color: YgeiaColors.accent,
    ),
  );
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
