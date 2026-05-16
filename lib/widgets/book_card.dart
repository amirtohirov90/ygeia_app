import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/book.dart';
import '../data/books.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';

class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({super.key, required this.book});

  Future<void> _openUrl() async {
    final uri = Uri.parse(kBuyUrl);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Color get _coverColor => book.accentColor == 'rose'
      ? YgeiaColors.accentSecondary
      : YgeiaColors.accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: YgeiaSpacing.md),
      padding: const EdgeInsets.all(YgeiaSpacing.md),
      decoration: BoxDecoration(
        color: YgeiaColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 80,
            decoration: BoxDecoration(
              color: _coverColor,
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  book.title,
                  style: GoogleFonts.fraunces(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                    color: YgeiaColors.bgBase,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: YgeiaSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  style: GoogleFonts.fraunces(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: YgeiaColors.textPrimary,
                  ),
                ),
                const SizedBox(height: YgeiaSpacing.xs),
                Text(
                  book.subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: YgeiaColors.textSecondary,
                  ),
                ),
                const SizedBox(height: YgeiaSpacing.xs),
                Text(
                  book.description,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: YgeiaColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: YgeiaSpacing.md),
                if (book.available) ...[
                  Row(
                    children: [
                      Text(
                        '${book.priceCurrent} ₽',
                        style: GoogleFonts.fraunces(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: YgeiaColors.accent,
                        ),
                      ),
                      const SizedBox(width: YgeiaSpacing.sm),
                      Text(
                        '${book.priceOld} ₽',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: YgeiaColors.textMuted,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const Spacer(),
                      OutlinedButton.icon(
                        onPressed: _openUrl,
                        icon: const Icon(LucideIcons.shoppingBag, size: 14),
                        label: const Text('Купить'),
                        style: _buttonStyle,
                      ),
                    ],
                  ),
                ] else ...[
                  Text(
                    'В разработке · можно оформить предзаказ',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: YgeiaColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: YgeiaSpacing.sm),
                  OutlinedButton.icon(
                    onPressed: _openUrl,
                    icon: const Icon(LucideIcons.bookmark, size: 14),
                    label: const Text('Предзаказ'),
                    style: _buttonStyle,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  ButtonStyle get _buttonStyle => OutlinedButton.styleFrom(
        foregroundColor: YgeiaColors.accent,
        side: const BorderSide(color: YgeiaColors.accent, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        textStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      );
}
