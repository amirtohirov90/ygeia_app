import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../services/auth_service.dart';
import '../services/user_profile_service.dart';
import '../services/subscription_service.dart';
import '../services/notification_service.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../config/feature_flags.dart';
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
    final sub = await SubscriptionService.getSubscription();
    final notifEnabled = await NotificationService.isEnabled();
    if (mounted) {
      setState(() {
        _nickname = nick;
        _avatarPath = avatar;
        _subscription = sub;
        _notificationsEnabled = notifEnabled;
        _loading = false;
      });
    }
  }

  Future<void> _pickAvatar(ImageSource source) async {
    Navigator.pop(context);
    final path = await _profileService.pickAndSaveAvatar(source);
    if (path != null && mounted) {
      setState(() => _avatarPath = path);
    }
  }

  void _showAvatarOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: YgeiaColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: YgeiaColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text('Изменить фото', style: YgeiaTypography.h3),
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
        backgroundColor: YgeiaColors.bgCard,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Ваш никнейм', style: YgeiaTypography.h3),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          maxLength: 24,
          style: YgeiaTypography.body,
          decoration: InputDecoration(
            hintText: 'Введите никнейм',
            hintStyle:
                GoogleFonts.inter(fontSize: 14, color: YgeiaColors.textMuted),
            filled: true,
            fillColor: YgeiaColors.bgCardElevated,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена',
                style: GoogleFonts.inter(color: YgeiaColors.textMuted)),
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
              backgroundColor: YgeiaColors.accent,
              foregroundColor: YgeiaColors.white,
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
          backgroundColor: YgeiaColors.bgBase,
          appBar: AppBar(
            title: Text('Профиль', style: YgeiaTypography.h2),
            backgroundColor: YgeiaColors.bgBase,
            elevation: 0,
          ),
          body: _loading
              ? const Center(
                  child: CircularProgressIndicator(color: YgeiaColors.accent))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const SizedBox(height: 16),

                    // ── Avatar + Name ───────────────────────────────────
                    Center(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              GestureDetector(
                                onTap: _showAvatarOptions,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: YgeiaColors.accent,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: YgeiaColors.accent
                                            .withOpacity(0.22),
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
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: _showAvatarOptions,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: const BoxDecoration(
                                      color: YgeiaColors.accent,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.camera_alt_rounded,
                                        size: 16, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(displayName, style: YgeiaTypography.h2),
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: _editNickname,
                                child: const Icon(Icons.edit_outlined,
                                    size: 18, color: YgeiaColors.accent),
                              ),
                            ],
                          ),

                          if (_nickname != null && user?.email != null)
                            Text(user!.email!, style: YgeiaTypography.caption),

                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: _editNickname,
                            child: Text(
                              _nickname == null || _nickname!.isEmpty
                                  ? '+ Добавить никнейм'
                                  : 'Изменить никнейм',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: YgeiaColors.accent,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Subscription card ───────────────────────────────
                    if (FeatureFlags.kClubEnabled) ...[
                      _buildSubscriptionCard(),
                      const SizedBox(height: 20),
                    ],

                    // ── Auth button ─────────────────────────────────────
                    if (user == null)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const AuthScreen()),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: YgeiaColors.accent,
                            side: const BorderSide(
                                color: YgeiaColors.accent, width: 1.5),
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999)),
                          ),
                          child: const Text('Войти / Зарегистрироваться'),
                        ),
                      ),

                    const SizedBox(height: 20),

                    // ── Menu ────────────────────────────────────────────
                    _MenuItem(
                        icon: Icons.bookmark_outline,
                        title: 'Сохранённые'),
                    if (FeatureFlags.kPaymentsEnabled)
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

                    const SizedBox(height: 28),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildSubscriptionCard() {
    final sub = _subscription;

    // Active club subscription
    if (sub != null && sub.isActive && sub.isClub) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [YgeiaColors.accent, Color(0xFF40916C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: YgeiaColors.accent.withOpacity(0.22),
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
                        color: Colors.white),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sub.expiresAt != null
                        ? 'Активен · ${sub.expiresLabel}'
                        : 'Активен',
                    style: GoogleFonts.inter(
                        fontSize: 12, color: Colors.white.withOpacity(0.85)),
                  ),
                ],
              ),
            ),
            if (sub.isExpiringSoon)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: YgeiaColors.accentSecondary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Скоро истечёт',
                  style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
          ],
        ),
      );
    }

    // Book purchased
    if (sub != null && sub.isActive && sub.isBook) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: YgeiaColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: YgeiaColors.accent.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.menu_book,
                color: YgeiaColors.accent, size: 28),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                sub.planTitle,
                style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: YgeiaColors.textPrimary),
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: YgeiaColors.accentSoft,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('Куплено',
                  style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: YgeiaColors.accent)),
            ),
          ],
        ),
      );
    }

    // No subscription — CTA
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: YgeiaColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: YgeiaColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: YgeiaColors.accentSoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.stars_outlined,
                color: YgeiaColors.accent, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Клуб ygeia',
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: YgeiaColors.textPrimary)),
                Text('Эксклюзивный контент',
                    style: YgeiaTypography.caption),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios,
              size: 14, color: YgeiaColors.textMuted),
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
        color: YgeiaColors.bgCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: YgeiaColors.accent),
        title: Text(title, style: YgeiaTypography.body),
        trailing: const Icon(Icons.arrow_forward_ios,
            size: 14, color: YgeiaColors.textMuted),
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
        color: YgeiaColors.bgCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: const Icon(Icons.notifications_outlined,
            color: YgeiaColors.accent),
        title: Text('Уведомления', style: YgeiaTypography.body),
        subtitle: Text(
          enabled ? 'Утро 8:00 · Вечер 20:00' : 'Выключены',
          style: YgeiaTypography.caption,
        ),
        trailing: Switch(
          value: enabled,
          onChanged: onChanged,
          activeColor: YgeiaColors.accent,
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
    final color = isDestructive ? Colors.red[700]! : YgeiaColors.textPrimary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDestructive ? Colors.red[50] : YgeiaColors.bgCardElevated,
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
