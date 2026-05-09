import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../services/auth_service.dart';
import '../services/user_profile_service.dart';
import '../services/english_service.dart';
import '../services/nutrition_service.dart';
import '../services/subscription_service.dart';
import '../services/notification_service.dart';
import 'auth_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _profileService = UserProfileService();
  final _authService = AuthService();

  String? _nickname;
  String? _avatarPath;
  EnglishProgress _englishProgress = EnglishProgress.empty();
  SubscriptionStatus? _subscription;
  bool _notificationsEnabled = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final nick = await _profileService.getNickname();
    final avatar = await _profileService.getAvatarPath();
    final engProgress = await EnglishService().getProgress();
    final sub = await SubscriptionService.getSubscription();
    final notifEnabled = await NotificationService.isEnabled();
    if (mounted) {
      setState(() {
        _nickname = nick;
        _avatarPath = avatar;
        _englishProgress = engProgress;
        _subscription = sub;
        _notificationsEnabled = notifEnabled;
        _loading = false;
      });
    }
  }

  Future<void> _pickAvatar(ImageSource source) async {
    Navigator.pop(context); // close bottom sheet
    final path = await _profileService.pickAndSaveAvatar(source);
    if (path != null && mounted) {
      setState(() => _avatarPath = path);
    }
  }

  void _showAvatarOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFFAF4EC),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: const Color(0xFFDDD5C8),
                  borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 20),
            Text('Изменить фото',
                style: GoogleFonts.playfairDisplay(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _SheetOption(
              icon: Icons.photo_camera_outlined,
              label: 'Сделать фото',
              onTap: () => _pickAvatar(ImageSource.camera),
            ),
            const SizedBox(height: 8),
            _SheetOption(
              icon: Icons.photo_library_outlined,
              label: 'Выбрать из галереи',
              onTap: () => _pickAvatar(ImageSource.gallery),
            ),
            if (_avatarPath != null) ...[
              const SizedBox(height: 8),
              _SheetOption(
                icon: Icons.delete_outline,
                label: 'Удалить фото',
                isDestructive: true,
                onTap: () async {
                  Navigator.pop(context);
                  await _profileService.removeAvatar();
                  if (mounted) setState(() => _avatarPath = null);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _editNickname() {
    final ctrl = TextEditingController(text: _nickname ?? '');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFFAF4EC),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Ваш никнейм',
            style: GoogleFonts.playfairDisplay(
                fontWeight: FontWeight.bold, fontSize: 18)),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          maxLength: 24,
          decoration: InputDecoration(
            hintText: 'Введите никнейм',
            hintStyle: GoogleFonts.inter(color: const Color(0xFF999999)),
            filled: true,
            fillColor: const Color(0xFFF0E8DA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          style: GoogleFonts.inter(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена',
                style: GoogleFonts.inter(color: const Color(0xFF888888))),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final text = ctrl.text.trim();
              if (text.isNotEmpty) {
                await _profileService.setNickname(text);
                if (mounted) setState(() => _nickname = text);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2D6A4F),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: Text('Сохранить',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        final user = snapshot.data;
        final displayName = _nickname?.isNotEmpty == true
            ? _nickname!
            : (user?.email?.split('@').first ?? 'Гость');

        return Scaffold(
          backgroundColor: const Color(0xFFF0E8DA),
          appBar: AppBar(
            backgroundColor: const Color(0xFF2D6A4F),
            title: Text('Профиль',
                style: GoogleFonts.playfairDisplay(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
          ),
          body: _loading
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFF2D6A4F)))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const SizedBox(height: 16),

                    // ── Avatar + Name ───────────────────────────────────────
                    Center(
                      child: Column(
                        children: [
                          // Avatar circle with camera badge
                          Stack(
                            children: [
                              GestureDetector(
                                onTap: _showAvatarOptions,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2D6A4F),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF2D6A4F)
                                            .withOpacity(0.25),
                                        blurRadius: 16,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: _avatarPath != null
                                      ? Image.file(File(_avatarPath!),
                                          fit: BoxFit.cover)
                                      : const Icon(Icons.eco,
                                          size: 50, color: Colors.white),
                                ),
                              ),
                              // Camera badge
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: _showAvatarOptions,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF2D6A4F),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                        Icons.camera_alt_rounded,
                                        size: 16,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Display name (nickname or email)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                displayName,
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1A1A1A),
                                ),
                              ),
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: _editNickname,
                                child: const Icon(Icons.edit_outlined,
                                    size: 18, color: Color(0xFF2D6A4F)),
                              ),
                            ],
                          ),

                          if (_nickname != null && user?.email != null)
                            Text(
                              user!.email!,
                              style: GoogleFonts.inter(
                                  fontSize: 13, color: const Color(0xFF999999)),
                            ),

                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: _editNickname,
                            child: Text(
                              _nickname == null || _nickname!.isEmpty
                                  ? '+ Добавить никнейм'
                                  : 'Изменить никнейм',
                              style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: const Color(0xFF2D6A4F),
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Subscription card ───────────────────────────────────
                    _buildSubscriptionCard(),

                    const SizedBox(height: 16),

                    // ── Progress stats ──────────────────────────────────────
                    _buildProgressStats(),

                    const SizedBox(height: 20),

                    // ── Auth button ─────────────────────────────────────────
                    if (user == null)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (_) => const AuthScreen())),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2D6A4F),
                            foregroundColor: Colors.white,
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text('Войти / Зарегистрироваться',
                              style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),

                    const SizedBox(height: 20),

                    // ── Menu items ──────────────────────────────────────────
                    _MenuItem(
                        icon: Icons.bookmark_outline,
                        title: 'Сохранённые'),
                    _MenuItem(
                        icon: Icons.shopping_bag_outlined,
                        title: 'Мои покупки'),
                    _MenuItem(
                        icon: Icons.settings_outlined,
                        title: 'Настройки'),
                    _NotificationTile(
                      enabled: _notificationsEnabled,
                      onChanged: (v) async {
                        await NotificationService.setEnabled(v);
                        setState(() => _notificationsEnabled = v);
                      },
                    ),

                    if (user != null) ...[
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => _authService.signOut(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red[700],
                            side: BorderSide(color: Colors.red[700]!),
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text('Выйти',
                              style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildSubscriptionCard() {
    final sub = _subscription;

    // Активная подписка клуба
    if (sub != null && sub.isActive && sub.isClub) {
      final expiring = sub.isExpiringSoon;
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2D6A4F), Color(0xFF40916C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2D6A4F).withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.stars, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sub.planTitle,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sub.expiresAt != null
                        ? 'Активен · ${sub.expiresLabel}'
                        : 'Активен',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                ],
              ),
            ),
            if (expiring)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE07A5F),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Скоро истечёт',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      );
    }

    // Куплена книга (без срока)
    if (sub != null && sub.isActive && sub.isBook) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFAF4EC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2D6A4F).withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.menu_book, color: Color(0xFF2D6A4F), size: 28),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                sub.planTitle,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF2D6A4F).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Куплено',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2D6A4F),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Нет подписки — CTA
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF4EC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDDD5C8)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF2D6A4F).withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.stars_outlined,
                color: Color(0xFF2D6A4F), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Клуб ygeia',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                Text(
                  'Эксклюзивный контент и сообщество',
                  style: GoogleFonts.inter(
                      fontSize: 12, color: const Color(0xFF999999)),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios,
              size: 14, color: Color(0xFF999999)),
        ],
      ),
    );
  }

  Widget _buildProgressStats() {
    final completedLessons =
        _englishProgress.lessons.values.where((l) => l.completed).length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF4EC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Мой прогресс',
              style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A))),
          const SizedBox(height: 14),
          Row(
            children: [
              _ProgressStat(
                emoji: '⚡',
                value: '${_englishProgress.totalXp}',
                label: 'XP',
              ),
              _ProgressStat(
                emoji: '🔥',
                value: '${_englishProgress.currentStreak}',
                label: 'Серия дней',
              ),
              _ProgressStat(
                emoji: '📚',
                value: '$completedLessons',
                label: 'Уроков',
              ),
              _ProgressStat(
                emoji: '⭐',
                value: _englishProgress.lessons.values
                    .fold<int>(0, (sum, l) => sum + l.stars)
                    .toString(),
                label: 'Звёзд',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressStat extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;

  const _ProgressStat(
      {required this.emoji, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 4),
          Text(value,
              style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A1A))),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 10, color: const Color(0xFF999999)),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const _MenuItem({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF4EC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF2D6A4F)),
        title: Text(title,
            style: GoogleFonts.inter(
                fontSize: 15, color: const Color(0xFF1A1A1A))),
        trailing: const Icon(Icons.arrow_forward_ios,
            size: 14, color: Color(0xFF999999)),
        onTap: () {},
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const _NotificationTile({required this.enabled, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF4EC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: const Icon(Icons.notifications_outlined,
            color: Color(0xFF2D6A4F)),
        title: Text('Уведомления',
            style: GoogleFonts.inter(
                fontSize: 15, color: const Color(0xFF1A1A1A))),
        subtitle: Text(
          enabled ? 'Утро 8:00 · Английский 20:00' : 'Выключены',
          style: GoogleFonts.inter(
              fontSize: 12, color: const Color(0xFF999999)),
        ),
        trailing: Switch(
          value: enabled,
          onChanged: onChanged,
          activeColor: const Color(0xFF2D6A4F),
        ),
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SheetOption({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        isDestructive ? Colors.red[700]! : const Color(0xFF1A1A1A);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDestructive
              ? Colors.red[50]
              : const Color(0xFFF0E8DA),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 14),
            Text(label,
                style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: color)),
          ],
        ),
      ),
    );
  }
}
