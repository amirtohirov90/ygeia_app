import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'theme/colors.dart';
import 'screens/feed_screen.dart';
import 'screens/lessons_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/nutrition/nutrition_screen.dart';
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

  // 4 tabs: Лента · Уроки · Профиль · КБЖУ
  // Club and Shop are hidden behind kClubEnabled / kPaymentsEnabled flags
  static const List<Widget> _screens = [
    FeedScreen(),
    LessonsScreen(),
    ProfileScreen(),
    NutritionScreen(),
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
        onDestinationSelected: (index) =>
            setState(() => _currentIndex = index),
        backgroundColor: YgeiaColors.bgCard,
        indicatorColor: YgeiaColors.accentSoft,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Лента',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Уроки',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Профиль',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'КБЖУ',
          ),
        ],
      ),
    );
  }
}
