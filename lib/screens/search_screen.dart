import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/post.dart';
import '../services/firestore_service.dart';
import '../widgets/highlighted_text.dart';
import 'post_detail_screen.dart';
import 'club_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';
  List<Post> _allPosts = [];
  bool _postsLoaded = false;

  final _lessons = const [
    {'title': 'Приветствие солнца — Сурья Намаскар', 'cat': 'Йога'},
    {'title': 'Поза дерева — Врикшасана', 'cat': 'Йога'},
    {'title': 'Поза воина I — Вирабхадрасана', 'cat': 'Йога'},
    {'title': 'Поза кошки-коровы — Марджариасана', 'cat': 'Йога'},
    {'title': 'Шавасана — поза мёртвого', 'cat': 'Йога'},
    {'title': 'Принципы осознанного питания', 'cat': 'Питание'},
    {'title': 'Что есть на завтрак для энергии', 'cat': 'Питание'},
    {'title': 'Интервальное голодание 16:8', 'cat': 'Питание'},
    {'title': 'Воспаление и питание', 'cat': 'Питание'},
    {'title': 'Гидратация: сколько воды нужно', 'cat': 'Питание'},
    {'title': 'Как работает петля привычки', 'cat': 'Привычки'},
    {'title': 'Правило 2 минут', 'cat': 'Привычки'},
    {'title': 'Стекинг привычек', 'cat': 'Привычки'},
    {'title': 'Как не сломать цепочку', 'cat': 'Привычки'},
    {'title': 'Окружение как архитектура поведения', 'cat': 'Привычки'},
    {'title': 'Медитация для начинающих', 'cat': 'Медитация 🔒'},
    {'title': 'Дыхание 4-7-8', 'cat': 'Медитация 🔒'},
    {'title': 'Медитация сканирования тела', 'cat': 'Медитация 🔒'},
    {'title': 'Медитация любящей доброты', 'cat': 'Медитация 🔒'},
    {'title': 'Почему сон важнее тренировок', 'cat': 'Сон 🔒'},
    {'title': 'Ритуал отхода ко сну', 'cat': 'Сон 🔒'},
    {'title': 'Температура, темнота, тишина', 'cat': 'Сон 🔒'},
    {'title': 'Питание и сон', 'cat': 'Сон 🔒'},
  ];

  final _products = const [
    {'title': 'Базис', 'subtitle': 'ЗОЖ и привычки • 490 ₽'},
    {'title': 'Ритм', 'subtitle': 'Греческая эстетика • 590 ₽'},
    {'title': 'Дзен', 'subtitle': 'Азиатская философия • 590 ₽'},
    {'title': 'Калибр', 'subtitle': 'Деньги и качество • 690 ₽'},
  ];

  final _clubContent = const [
    'Закрытые уроки медитации',
    'Живые эфиры каждую неделю',
    'Персональная поддержка',
    'Сообщество единомышленниц',
    'Эксклюзивные материалы по питанию',
    'Закрытый чат участников',
  ];

  @override
  void initState() {
    super.initState();
    FirestoreService().getPosts().first.then((posts) {
      if (mounted) setState(() {
        _allPosts = posts.isNotEmpty ? posts : _staticPosts.map(Post.fromMap).toList();
        _postsLoaded = true;
      });
    }).catchError((_) {
      if (mounted) setState(() {
        _allPosts = _staticPosts.map(Post.fromMap).toList();
        _postsLoaded = true;
      });
    });
  }

  bool _matches(String text) =>
      text.toLowerCase().contains(_query.toLowerCase());

  List<Post> get _matchedPosts => _query.isEmpty
      ? []
      : _allPosts.where((p) =>
          _matches(p.title) || _matches(p.body) || _matches(p.category)).toList();

  List<Map<String, String>> get _matchedLessons => _query.isEmpty
      ? []
      : _lessons
          .where((l) => _matches(l['title']!) || _matches(l['cat']!))
          .toList();

  List<Map<String, String>> get _matchedProducts => _query.isEmpty
      ? []
      : _products
          .where((p) => _matches(p['title']!) || _matches(p['subtitle']!))
          .toList();

  List<String> get _matchedClub => _query.isEmpty
      ? []
      : _clubContent.where(_matches).toList();

  bool get _hasResults =>
      _matchedPosts.isNotEmpty ||
      _matchedLessons.isNotEmpty ||
      _matchedProducts.isNotEmpty ||
      _matchedClub.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0E8DA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D6A4F),
        iconTheme: const IconThemeData(color: Colors.white),
        title: TextField(
          controller: _controller,
          autofocus: true,
          style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintText: 'Поиск по всему приложению...',
            hintStyle: GoogleFonts.inter(
                color: Colors.white.withOpacity(0.6), fontSize: 15),
            border: InputBorder.none,
          ),
          onChanged: (v) => setState(() => _query = v),
        ),
        actions: [
          if (_query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                _controller.clear();
                setState(() => _query = '');
              },
            ),
        ],
      ),
      body: _query.isEmpty
          ? _emptyState()
          : !_postsLoaded
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFF2D6A4F)))
              : !_hasResults
                  ? _noResults()
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        if (_matchedPosts.isNotEmpty) ...[
                          _sectionHeader('Посты', Icons.article_outlined),
                          ..._matchedPosts.map((p) => _postTile(context, p)),
                        ],
                        if (_matchedLessons.isNotEmpty) ...[
                          _sectionHeader('Уроки', Icons.menu_book_outlined),
                          ..._matchedLessons
                              .map((l) => _lessonTile(context, l)),
                        ],
                        if (_matchedProducts.isNotEmpty) ...[
                          _sectionHeader('Магазин', Icons.shopping_bag_outlined),
                          ..._matchedProducts.map((p) => _productTile(p)),
                        ],
                        if (_matchedClub.isNotEmpty) ...[
                          _sectionHeader('Клуб', Icons.stars_outlined),
                          ..._matchedClub.map((c) => _clubTile(context, c)),
                        ],
                      ],
                    ),
    );
  }

  Widget _emptyState() => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search, size: 64, color: Color(0xFFCCCCCC)),
            const SizedBox(height: 12),
            Text(
              'Ищи посты, уроки, товары',
              style: GoogleFonts.inter(
                  fontSize: 15, color: const Color(0xFF999999)),
            ),
          ],
        ),
      );

  Widget _noResults() => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 56, color: Color(0xFFCCCCCC)),
            const SizedBox(height: 12),
            Text(
              'Ничего не найдено',
              style: GoogleFonts.inter(
                  fontSize: 15, color: const Color(0xFF999999)),
            ),
          ],
        ),
      );

  Widget _sectionHeader(String title, IconData icon) => Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 8),
        child: Row(
          children: [
            Icon(icon, size: 16, color: const Color(0xFF2D6A4F)),
            const SizedBox(width: 6),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2D6A4F),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      );

  Widget _postTile(BuildContext context, Post post) => GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PostDetailScreen(post: post)),
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFAF4EC),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (post.category.isNotEmpty)
                Text(
                  post.category,
                  style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFF2D6A4F),
                      fontWeight: FontWeight.w600),
                ),
              const SizedBox(height: 4),
              HighlightedText(
                text: post.title,
                query: _query,
                baseStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 4),
              HighlightedText(
                text: post.body,
                query: _query,
                baseStyle: GoogleFonts.inter(
                    fontSize: 13, color: const Color(0xFF666666)),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );

  Widget _lessonTile(BuildContext context, Map<String, String> lesson) {
    final isPremium =
        lesson['cat']!.contains('🔒');
    return GestureDetector(
      onTap: isPremium
          ? () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ClubScreen()),
              )
          : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFAF4EC),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson['cat']!,
                    style: GoogleFonts.inter(
                        fontSize: 11,
                        color: isPremium
                            ? const Color(0xFFE07A5F)
                            : const Color(0xFF2D6A4F),
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  HighlightedText(
                    text: lesson['title']!,
                    query: _query,
                    baseStyle: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isPremium
                          ? const Color(0xFF999999)
                          : const Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
            ),
            if (isPremium)
              const Icon(Icons.lock_outline,
                  size: 16, color: Color(0xFFCCCCCC)),
          ],
        ),
      ),
    );
  }

  Widget _productTile(Map<String, String> product) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFAF4EC),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.menu_book,
                size: 28, color: Color(0xFF2D6A4F)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HighlightedText(
                    text: product['title']!,
                    query: _query,
                    baseStyle: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  HighlightedText(
                    text: product['subtitle']!,
                    query: _query,
                    baseStyle: GoogleFonts.inter(
                        fontSize: 12, color: const Color(0xFF999999)),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _clubTile(BuildContext context, String text) => GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ClubScreen()),
        ),
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF4EC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.stars,
                      size: 20, color: Color(0xFF2D6A4F)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: HighlightedText(
                      text: text,
                      query: _query,
                      baseStyle: GoogleFonts.inter(
                          fontSize: 14, color: const Color(0xFF1A1A1A)),
                    ),
                  ),
                  const Icon(Icons.lock_outline,
                      size: 16, color: Color(0xFFCCCCCC)),
                ],
              ),
            ),
          ],
        ),
      );
}

const List<Map<String, String>> _staticPosts = [
  {
    'title': 'Утренняя йога: 5 асан для начала дня',
    'body': 'Начни утро с этих простых асан — они разбудят тело и настроят ум на продуктивный день.',
    'date': '9 мая 2026',
    'category': 'Йога',
  },
  {
    'title': 'Почему сахар по утрам — это плохая идея',
    'body': 'Резкий скачок глюкозы утром запускает цикл усталости и тяги к сладкому.',
    'date': '8 мая 2026',
    'category': 'Питание',
  },
  {
    'title': '3 привычки для здоровья без усилий',
    'body': 'Микро-привычки работают лучше жёстких систем.',
    'date': '7 мая 2026',
    'category': 'Привычки',
  },
];
