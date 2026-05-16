/// Feature flags — flip these to enable/disable entire product areas.
/// All flags are compile-time constants so dead code is eliminated in release.
class FeatureFlags {
  FeatureFlags._();

  /// English learning module (lessons, XP, streaks).
  /// Set true when content + gamification is ready.
  static const bool kEnglishEnabled = false;

  /// Club (community, exclusive content).
  /// Set true when payment + moderation are wired up.
  static const bool kClubEnabled = false;

  /// In-app purchases / YooKassa payments.
  /// Set true after ИП is registered and keys configured.
  static const bool kPaymentsEnabled = false;

  /// Карточки книг (Базис/Дзен/Ритм/Калибр) временно скрыты в MVP.
  /// Включить = true, когда будем готовы к монетизации (Фаза 4-5).
  /// Код книг сохранён: lib/data/books.dart, lib/widgets/book_card.dart
  static const bool kBooksEnabled = false;

  /// Default pillar tab on app start (one of: today/body/mind/emotions/meaning/life).
  static const String kDefaultPillar = 'today';
}
