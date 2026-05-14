import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/colors.dart';
import '../../widgets/feed_content.dart';
import '../profile_screen.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).textTheme.headlineLarge!;

    return Scaffold(
      backgroundColor: YgeiaColors.bgBase,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Доброе утро,',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: YgeiaColors.textSecondary,
              ),
            ),
            Text('Сегодня', style: base),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.user),
            color: YgeiaColors.textPrimary,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
          ),
        ],
      ),
      body: const FeedContent(),
    );
  }
}
