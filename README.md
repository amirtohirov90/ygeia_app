# ygeia

Wellness-приложение в эстетике spiritual minimalism.
Один тихий шаг в день.

## Концепция

8 столпов здоровья (Сон · Питание · Движение · Дыхание · Ум · Эмоции · Смысл · Связи), сжатые в UI до 5 разделов плюс главный экран:

- **Сегодня** — точка входа дня
- **Тело** — Сон, Питание, Движение, Дыхание
- **Ум** — Стресс, Фокус, Медитация
- **Эмоции** — Mood, Журнал
- **Смысл** — Цели, Ритуалы, Благодарность
- **Жизнь** — Связи, Среда, Цифровая гигиена

## Текущий статус

- **Фаза 1** (завершена) — Дизайн-система, упрощённая навигация
- **Фаза 2** (завершена) — 6-разделная архитектура, перенос контента
- **Фаза 3** (в плане) — Трекеры, практики, инсайты, книги

## Стек

- Flutter (Dart)
- Firebase (Auth, Firestore, Messaging)
- Riverpod (state)
- SharedPreferences (локальное хранилище)
- Pillow + flutter_launcher_icons (генерация иконок)

## Архитектура

```
lib/
├── main.dart — навигация, IndexedStack 6 вкладок
├── theme/ — дизайн-система (colors, typography, spacing, app_theme)
├── screens/
│   ├── pillars/ — 6 экранов разделов
│   ├── nutrition/ — КБЖУ (открывается из Тело → Питание)
│   ├── english/ — английский (скрыт за kEnglishEnabled flag)
│   ├── feed_screen.dart — старая лента (не в навигации)
│   ├── lessons_screen.dart — Уроки (открывается из Тело → Движение)
│   ├── profile_screen.dart — Профиль (открывается из Today)
│   └── ...
├── widgets/
│   ├── feed_content.dart — лента контента
│   ├── pillar_section_card.dart — карточка раздела
│   ├── pillar_app_bar.dart — унифицированная AppBar для разделов
│   └── coming_soon_section.dart — заглушка для разделов Фазы 3
├── services/ — Firebase, уведомления, КБЖУ, профиль
└── config/feature_flags.dart — feature flags
```

## Запуск

```sh
cd C:\ygeia_app
puro use ygeia
puro flutter pub get
puro flutter run -d <device-id>
```

Дизайн-токены: `lib/theme/colors.dart`  
Палитра: шалфейный (`#5B7F6A`) · пыльно-розовый (`#D4A5A5`) · тёплый бежевый
