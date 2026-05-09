import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;
  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  bool _liked = false;
  int _likes = 0;

  @override
  void initState() {
    super.initState();
    _loadLikeState();
  }

  Future<void> _loadLikeState() async {
    final prefs = await SharedPreferences.getInstance();
    final likedPosts = prefs.getStringList('liked_posts') ?? [];
    if (mounted) {
      setState(() {
        _liked = likedPosts.contains(widget.post.id);
        _likes = widget.post.likes;
      });
    }
  }

  Future<void> _toggleLike() async {
    final prefs = await SharedPreferences.getInstance();
    final likedPosts = prefs.getStringList('liked_posts') ?? [];
    final postRef =
        FirebaseFirestore.instance.collection('posts').doc(widget.post.id);

    if (_liked) {
      likedPosts.remove(widget.post.id);
      setState(() {
        _liked = false;
        _likes = (_likes - 1).clamp(0, 9999);
      });
      postRef.update({'likes': FieldValue.increment(-1)});
    } else {
      likedPosts.add(widget.post.id);
      setState(() {
        _liked = true;
        _likes += 1;
      });
      postRef.update({'likes': FieldValue.increment(1)});
    }
    await prefs.setStringList('liked_posts', likedPosts);
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList('favorite_posts') ?? [];
    final isFav = favs.contains(widget.post.id);
    if (isFav) {
      favs.remove(widget.post.id);
    } else {
      favs.add(widget.post.id);
    }
    await prefs.setStringList('favorite_posts', favs);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isFav ? 'Удалено из сохранённых' : 'Добавлено в сохранённые',
            style: GoogleFonts.inter(fontSize: 13),
          ),
          duration: const Duration(seconds: 1),
          backgroundColor: const Color(0xFF2D6A4F),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F2),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: post.imageUrl != null ? 280 : 0,
            pinned: true,
            backgroundColor: const Color(0xFF2D6A4F),
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: post.imageUrl != null
                ? FlexibleSpaceBar(
                    background: Image.network(
                      post.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFF2D6A4F).withOpacity(0.3),
                      ),
                    ),
                  )
                : null,
            actions: [
              FutureBuilder<SharedPreferences>(
                future: SharedPreferences.getInstance(),
                builder: (context, snap) {
                  final favs =
                      snap.data?.getStringList('favorite_posts') ?? [];
                  final isFav = favs.contains(post.id);
                  return IconButton(
                    icon: Icon(
                      isFav ? Icons.bookmark : Icons.bookmark_border,
                      color: Colors.white,
                    ),
                    onPressed: _toggleFavorite,
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (post.category.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D6A4F).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        post.category,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2D6A4F),
                        ),
                      ),
                    ),
                  Text(
                    post.title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1A1A),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    post.date,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: const Color(0xFF999999),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    post.body,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: const Color(0xFF333333),
                      height: 1.8,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _toggleLike,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: _liked
                                ? const Color(0xFFE07A5F).withOpacity(0.1)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _liked
                                  ? const Color(0xFFE07A5F)
                                  : const Color(0xFFE0E0E0),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _liked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 18,
                                color: _liked
                                    ? const Color(0xFFE07A5F)
                                    : const Color(0xFF999999),
                              ),
                              if (_likes > 0) ...[
                                const SizedBox(width: 6),
                                Text(
                                  '$_likes',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: _liked
                                        ? const Color(0xFFE07A5F)
                                        : const Color(0xFF999999),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
