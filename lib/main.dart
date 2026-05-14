import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'theme/colors.dart';
import 'screens/onboarding_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/pillars/today_screen.dart';
import 'screens/pillars/body_screen.dart';
import 'screens/pillars/mind_screen.dart';
import 'screens/pillars/emotions_screen.dart';
import 'screens/pillars/meaning_screen.dart';
import 'screens/pillars/life_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.init();
  runApp(const YgeiaApp());
}

class YgeiaApp extends StatelessWidget {
  const YgeiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ygeia',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const _AppEntry(),
    );
  }
}

class _AppEntry extends StatefulWidget {
  const _AppEntry();

  @override
  State<_AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<_AppEntry> {
  bool _splashDone = false;
  bool _onboardingDone = false;
  bool _prefsLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _onboardingDone = prefs.getBool('onboarding_done') ?? false;
      _prefsLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_prefsLoaded || !_splashDone) {
      return SplashScreen(onDone: () {
        if (mounted) setState(() => _splashDone = true);
      });
    }
    if (!_onboardingDone) {
      return OnboardingScreen(
        onDone: () {
          if (mounted) setState(() => _onboardingDone = true);
        },
      );
    }
    return const MainScreen();
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // 6 pillars: Сегодня · Тело · Ум · Эмоции · Смысл · Жизнь
  // FeedScreen / LessonsScreen / ProfileScreen / NutritionScreen
  // are intentionally retained off-navigation — they return in Phase 2.2 and 2.3.
  static const List<Widget> _screens = [
    TodayScreen(),
    BodyScreen(),
    MindScreen(),
    EmotionsScreen(),
    MeaningScreen(),
    LifeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        backgroundColor: YgeiaColors.bgBase,
        elevation: 3,
        shadowColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        destinations: const [
          NavigationDestination(
              icon: Icon(LucideIcons.sun), label: 'Сегодня'),
          NavigationDestination(
              icon: Icon(LucideIcons.activity), label: 'Тело'),
          NavigationDestination(
              icon: Icon(LucideIcons.brain), label: 'Ум'),
          NavigationDestination(
              icon: Icon(LucideIcons.heart), label: 'Эмоции'),
          NavigationDestination(
              icon: Icon(LucideIcons.compass), label: 'Смысл'),
          NavigationDestination(
              icon: Icon(LucideIcons.users), label: 'Жизнь'),
        ],
      ),
    );
  }
}
