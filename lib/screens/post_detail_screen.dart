import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/post.dart';
import '../services/firestore_service.dart';
import 'auth_screen.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;
  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final FirestoreService _service = FirestoreService();
  final TextEditingController _commentController = TextEditingController();
  bool _liked = false;
  int _likes = 0;
  List<String> _likedByEmails = [];
  bool _isFav = false;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _likes = widget.post.likes;
    _likedByEmails = List.from(widget.post.likedByEmails);
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final likedPosts = prefs.getStringList('liked_posts') ?? [];
    final favPosts = prefs.getStringList('favorite_posts') ?? [];
    if (mounted) {
      setState(() {
        _liked = likedPosts.contains(widget.post.id);
        _isFav = favPosts.contains(widget.post.id);
      });
    }
  }

  Future<void> _toggleLike() async {
    final prefs = await SharedPreferences.getInstance();
    final likedPosts = prefs.getStringList('liked_posts') ?? [];
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'anonymous';

    setState(() {
      if (_liked) {
        _liked = false;
        _likes = (_likes - 1).clamp(0, 9999);
        _likedByEmails.remove(email);
        likedPosts.remove(widget.post.id);
      } else {
        _liked = true;
        _likes += 1;
        if (!_likedByEmails.contains(email)) _likedByEmails.add(email);
        likedPosts.add(widget.post.id);
      }
    });

    await prefs.setStringList('liked_posts', likedPosts);
    await _service.toggleLike(widget.post.id, !_liked);
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
    setState(() => _isFav = !_isFav);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(_isFav ? 'Добавлено в сохранённые' : 'Удалено из сохранённых',
            style: GoogleFonts.inter(fontSize: 13)),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFF2D6A4F),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
    }
  }

  Future<void> _submitComment() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => const AuthScreen()));
      return;
    }
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    setState(() => _submitting = true);
    await _service.addComment(widget.post.id, text);
    _commentController.clear();
    if (mounted) setState(() => _submitting = false);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F2),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: post.imageUrl != null ? 260 : 0,
                  pinned: true,
                  backgroundColor: const Color(0xFF2D6A4F),
                  iconTheme: const IconThemeData(color: Colors.white),
                  flexibleSpace: post.imageUrl != null
                      ? FlexibleSpaceBar(
                          background: Image.network(post.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                  color: const Color(0xFF2D6A4F)
                                      .withOpacity(0.3))))
                      : null,
                  actions: [
                    IconButton(
                      icon: Icon(
                          _isFav ? Icons.bookmark : Icons.bookmark_border,
                          color: Colors.white),
                      onPressed: _toggleFav,
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
                            child: Text(post.category,
                                style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF2D6A4F))),
                          ),
                        Text(post.title,
                            style: GoogleFonts.playfairDisplay(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1A1A1A),
                                height: 1.3)),
                        const SizedBox(height: 8),
                        Text(post.date,
                            style: GoogleFonts.inter(
                                fontSize: 13, color: const Color(0xFF999999))),
                        const SizedBox(height: 20),
                        Text(post.body,
                            style: GoogleFonts.inter(
                                fontSize: 16,
                                color: const Color(0xFF333333),
                                height: 1.8)),
                        const SizedBox(height: 28),

                        // Лайки
                        _LikeSection(
                          liked: _liked,
                          likes: _likes,
                          likedByEmails: _likedByEmails,
                          onTap: _toggleLike,
                        ),

                        const SizedBox(height: 32),
                        const Divider(),
                        const SizedBox(height: 8),

                        // Комментарии
                        Text('Комментарии',
                            style: GoogleFonts.playfairDisplay(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1A1A1A))),
                        const SizedBox(height: 16),

                        StreamBuilder<List<Comment>>(
                          stream: _service.getComments(post.id),
                          builder: (context, snap) {
                            if (!snap.hasData || snap.data!.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Text('Будьте первым, кто напишет комментарий',
                                    style: GoogleFonts.inter(
                                        fontSize: 14,
                                        color: const Color(0xFF999999))),
                              );
                            }
                            final comments = snap.data!;
                            return Column(
                              children: comments
                                  .map((c) => _CommentTile(
                                        comment: c,
                                        postId: post.id,
                                        service: _service,
                                      ))
                                  .toList(),
                            );
                          },
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Поле ввода комментария
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: MediaQuery.of(context).viewInsets.bottom + 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, -3))
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    style: GoogleFonts.inter(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: FirebaseAuth.instance.currentUser != null
                          ? 'Напишите комментарий...'
                          : 'Войдите, чтобы комментировать',
                      hintStyle: GoogleFonts.inter(
                          fontSize: 14, color: const Color(0xFF999999)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF8F6F2),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                    onTap: () {
                      if (FirebaseAuth.instance.currentUser == null) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const AuthScreen()));
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _submitting ? null : _submitComment,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2D6A4F),
                      shape: BoxShape.circle,
                    ),
                    child: _submitting
                        ? const Padding(
                            padding: EdgeInsets.all(10),
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2),
                          )
                        : const Icon(Icons.send, color: Colors.white, size: 18),
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

class _LikeSection extends StatelessWidget {
  final bool liked;
  final int likes;
  final List<String> likedByEmails;
  final VoidCallback onTap;

  const _LikeSection({
    required this.liked,
    required this.likes,
    required this.likedByEmails,
    required this.onTap,
  });

  String _displayName(String email) {
    final name = email.split('@').first;
    return name[0].toUpperCase() + name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final shown = likedByEmails.take(5).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (likedByEmails.isNotEmpty) ...[
          Row(
            children: [
              ...shown.map((email) => Container(
                    width: 28,
                    height: 28,
                    margin: const EdgeInsets.only(right: 4),
                    decoration: const BoxDecoration(
                      color: Color(0xFF2D6A4F),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        _displayName(email)[0],
                        style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  )),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  likedByEmails.length == 1
                      ? 'Нравится ${_displayName(likedByEmails.first)}'
                      : likedByEmails.length <= 3
                          ? 'Нравится ${shown.map(_displayName).join(', ')}'
                          : 'Нравится ${shown.take(2).map(_displayName).join(', ')} и ещё ${likedByEmails.length - 2}',
                  style: GoogleFonts.inter(
                      fontSize: 13, color: const Color(0xFF444444)),
                  maxLines: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: liked
                  ? const Color(0xFFE07A5F).withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: liked
                    ? const Color(0xFFE07A5F)
                    : const Color(0xFFE0E0E0),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                    liked ? Icons.favorite : Icons.favorite_border,
                    size: 18,
                    color: liked
                        ? const Color(0xFFE07A5F)
                        : const Color(0xFF999999)),
                if (likes > 0) ...[
                  const SizedBox(width: 6),
                  Text('$likes',
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: liked
                              ? const Color(0xFFE07A5F)
                              : const Color(0xFF999999))),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CommentTile extends StatelessWidget {
  final Comment comment;
  final String postId;
  final FirestoreService service;

  const _CommentTile({
    required this.comment,
    required this.postId,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    final isOwn =
        FirebaseAuth.instance.currentUser?.uid == comment.userId;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFF2D6A4F),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(comment.initials,
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(comment.displayName,
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2D6A4F))),
                      if (isOwn)
                        GestureDetector(
                          onTap: () =>
                              service.deleteComment(postId, comment.id),
                          child: const Icon(Icons.delete_outline,
                              size: 16, color: Color(0xFFCCCCCC)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(comment.text,
                      style: GoogleFonts.inter(
                          fontSize: 14, color: const Color(0xFF333333))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
