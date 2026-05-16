import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';

class PillarAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final int italicFromIndex;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final double fontSize;

  const PillarAppBar({
    super.key,
    required this.title,
    required this.italicFromIndex,
    this.actions,
    this.automaticallyImplyLeading = false,
    this.fontSize = 28.0,
  });

  @override
  Widget build(BuildContext context) {
    const color = YgeiaColors.textPrimary;

    final normal = GoogleFonts.fraunces(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: color,
    );
    final italic = GoogleFonts.fraunces(
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      color: color,
      fontStyle: FontStyle.italic,
    );

    final before = title.substring(0, italicFromIndex);
    final after = title.substring(italicFromIndex);

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: automaticallyImplyLeading,
      foregroundColor: color,
      actions: actions,
      title: Text.rich(
        TextSpan(
          children: [
            if (before.isNotEmpty) TextSpan(text: before, style: normal),
            if (after.isNotEmpty) TextSpan(text: after, style: italic),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
