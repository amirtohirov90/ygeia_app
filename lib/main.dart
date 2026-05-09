import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'screens/feed_screen.dart';
import 'screens/lessons_screen.dart';
import 'screens/club_screen.dart';
import 'screens/shop_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const YgeiaApp());
}

class YgeiaApp extends StatelessWidget {
  const YgeiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ygeia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2D6A4F),
          primary: const Color(0xFF2D6A4F),
        ),
        textTheme: GoogleFonts.interTextTheme(),
        useMaterial3: true,
      ),
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

  final List<Widget> _screens = const [
    FeedScreen(),
    LessonsScreen(),
    ClubScreen(),
    ShopScreen(),
    ProfileScreen(),
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
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFF2D6A4F).withOpacity(0.15),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: Color(0xFF2D6A4F)),
            label: 'Лента',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon:
                Icon(Icons.menu_book, color: Color(0xFF2D6A4F)),
            label: 'Уроки',
          ),
          NavigationDestination(
            icon: Icon(Icons.stars_outlined),
            selectedIcon: Icon(Icons.stars, color: Color(0xFF2D6A4F)),
            label: 'Клуб',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon:
                Icon(Icons.shopping_bag, color: Color(0xFF2D6A4F)),
            label: 'Магазин',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon:
                Icon(Icons.person, color: Color(0xFF2D6A4F)),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}
