import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../widgets/feed_content.dart';
import '../../widgets/insight_card.dart';
import '../../services/daily_insight_service.dart';
import '../profile_screen.dart';
import '../search_screen.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  bool _showFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YgeiaColors.bgBase,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.search),
            color: YgeiaColors.textSecondary,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchScreen()),
            ),
          ),
          IconButton(
            icon: Icon(LucideIcons.bookmark),
            color: _showFavorites
                ? YgeiaColors.accent
                : YgeiaColors.textSecondary,
            onPressed: () => setState(() => _showFavorites = !_showFavorites),
          ),
          IconButton(
            icon: const Icon(LucideIcons.user),
            color: YgeiaColors.textSecondary,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: YgeiaSpacing.md),
            InsightCard(insight: DailyInsightService.todaysInsight()),
            const SizedBox(height: YgeiaSpacing.md),
            Expanded(
              child: FeedContent(showFavorites: _showFavorites),
            ),
          ],
        ),
      ),
    );
  }
}
