import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class UserProfileService {
  static const _nicknameKey = 'user_nickname';
  static const _avatarKey = 'user_avatar_path';

  // ── Nickname ─────────────────────────────────────────
  Future<String?> getNickname() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nicknameKey);
  }

  Future<void> setNickname(String nickname) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nicknameKey, nickname.trim());
  }

  // ── Avatar ───────────────────────────────────────────
  Future<String?> getAvatarPath() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString(_avatarKey);
    if (path == null) return null;
    // Verify the file still exists
    if (await File(path).exists()) return path;
    return null;
  }

  /// Picks an image from [source] (camera or gallery), copies it to the
  /// app's documents directory for a stable path, saves and returns the path.
  /// Returns null if the user cancelled.
  Future<String?> pickAndSaveAvatar(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (picked == null) return null;

    // Copy to stable app documents directory
    final dir = await getApplicationDocumentsDirectory();
    final destPath = '${dir.path}/user_avatar.jpg';
    await File(picked.path).copy(destPath);

    // Save path
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_avatarKey, destPath);
    return destPath;
  }

  Future<void> removeAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString(_avatarKey);
    if (path != null) {
      final file = File(path);
      if (await file.exists()) await file.delete();
    }
    await prefs.remove(_avatarKey);
  }

  /// Returns the display name to use in comments and elsewhere.
  /// Priority: nickname → email prefix → 'Пользователь'
  Future<String> getDisplayName({String? email}) async {
    final nick = await getNickname();
    if (nick != null && nick.isNotEmpty) return nick;
    if (email != null && email.contains('@')) return email.split('@').first;
    return 'Пользователь';
  }
}
