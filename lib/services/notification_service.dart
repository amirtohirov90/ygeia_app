import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const int _morningId = 1;
  static const int _eveningId = 2;

  static const String _channelId = 'ygeia_reminders';
  static const String _channelName = 'Напоминания ygeia';
  static const String _channelDesc = 'Утренние мотивашки и напоминание об английском';

  static const String _prefKey = 'notifications_enabled';

  // ── Init ─────────────────────────────────────────────────────────────────
  static Future<void> init() async {
    tz_data.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(settings);

    // Create notification channel
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            _channelId,
            _channelName,
            description: _channelDesc,
            importance: Importance.high,
          ),
        );

    // Request permission (Android 13+)
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    // Auto-restore schedules if previously enabled
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_prefKey) ?? false) {
      await scheduleAll();
    }
  }

  // ── Schedule helpers ─────────────────────────────────────────────────────
  static Future<void> scheduleAll() async {
    await scheduleMorningMotivation();
    await scheduleStreakReminder();
  }

  /// 08:00 ежедневно — утренняя мотивация
  static Future<void> scheduleMorningMotivation() async {
    final now = tz.TZDateTime.now(tz.local);
    var target =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 8, 0);
    if (target.isBefore(now)) {
      target = target.add(const Duration(days: 1));
    }

    final messages = [
      'Доброе утро! Сегодня отличный день для новой привычки 🌿',
      'Утро — лучшее время позаботиться о себе ✨',
      'Маленький шаг каждый день = большой результат ☀️',
      'Ты уже проснулась — это первый шаг 🌱',
      'Сегодня сделай одну вещь ради себя 💚',
    ];
    final msg = messages[now.day % messages.length];

    await _plugin.zonedSchedule(
      _morningId,
      'ygeia',
      msg,
      target,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// 20:00 ежедневно — напоминание об английском (серия)
  static Future<void> scheduleStreakReminder() async {
    final now = tz.TZDateTime.now(tz.local);
    var target =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 20, 0);
    if (target.isBefore(now)) {
      target = target.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      _eveningId,
      '🔥 Не теряй серию!',
      'Ещё не учила английский сегодня. Займёт всего 2 минуты!',
      target,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // ── On/Off ───────────────────────────────────────────────────────────────
  static Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefKey) ?? false;
  }

  static Future<void> setEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, enabled);
    if (enabled) {
      await scheduleAll();
    } else {
      await _plugin.cancelAll();
    }
  }

  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
