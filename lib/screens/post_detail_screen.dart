import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;
  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  // Like/comment UI is hidden in Phase 1.
  // Methods stay in firestore_service.dart for Phase 3 social features.
  bool _isFav = false;

  @override
  void initState() {
    super.initState();
    _loadFavState();
  }

  Future<void> _loadFavState() async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList('favorite_posts') ?? [];
    if (mounted) {
      setState(() => _isFav = favs.contains(widget.post.id));
    }
  }

  Future<void> _toggleFav() async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList('favorite_posts') ?? [];
    if (_isFav) {
      favs.remove(widget.post.id);
    } else {
      favs.add(widget.post.id);
    }
    await prefs.setStringList('favorite_posts', favs);
    if (!mounted) return;
    setState(() => _isFav = !_isFav);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        _isFav ? 'Добавлено в сохранённые' : 'Удалено из сохранённых',
        style: GoogleFonts.inter(fontSize: 13),
      ),
      duration: const Duration(seconds: 1),
      backgroundColor: YgeiaColors.accent,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Scaffold(
      backgroundColor: YgeiaColors.bgBase,
      body: CustomScrollView(
        slivers: [
          // ── App bar with hero image ────────────────────────────────────
          SliverAppBar(
            expandedHeight: post.imageUrl != null ? 260 : 0,
            pinned: true,
            backgroundColor: YgeiaColors.bgBase,
            foregroundColor: YgeiaColors.textPrimary,
            iconTheme: const IconThemeData(color: YgeiaColors.textPrimary),
            flexibleSpace: post.imageUrl != null
                ? FlexibleSpaceBar(
                    background: Image.network(
                      post.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: YgeiaColors.accentSoft,
                      ),
                    ),
                  )
                : null,
            actions: [
              IconButton(
                icon: Icon(
                  _isFav ? Icons.bookmark : Icons.bookmark_border,
                  color: _isFav
                      ? YgeiaColors.accent
                      : YgeiaColors.textSecondary,
                ),
                onPressed: _toggleFav,
              ),
            ],
          ),

          // ── Content ───────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category chip
                  if (post.category.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: YgeiaColors.accentSoft,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        post.category,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: YgeiaColors.accent,
                        ),
                      ),
                    ),

                  // Title
                  Text(
                    post.title,
                    style: YgeiaTypography.h2.copyWith(height: 1.3),
                  ),
                  const SizedBox(height: 8),

                  // Date
                  Text(post.date, style: YgeiaTypography.caption),
                  const SizedBox(height: 24),

                  // Divider
                  const Divider(color: YgeiaColors.divider, height: 1),
                  const SizedBox(height: 24),

                  // Body
                  Text(
                    post.body,
                    style: YgeiaTypography.body,
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Like/comment service methods remain in firestore_service.dart.
// They will be wired back into the UI when community features return in Phase 3.
