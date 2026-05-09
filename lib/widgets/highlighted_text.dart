import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HighlightedText extends StatelessWidget {
  final String text;
  final String query;
  final TextStyle? baseStyle;
  final int? maxLines;
  final TextOverflow? overflow;

  const HighlightedText({
    super.key,
    required this.text,
    required this.query,
    this.baseStyle,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final style = baseStyle ??
        GoogleFonts.inter(fontSize: 14, color: const Color(0xFF666666));

    if (query.isEmpty) {
      return Text(text, style: style, maxLines: maxLines, overflow: overflow);
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final spans = <TextSpan>[];
    int start = 0;

    while (true) {
      final index = lowerText.indexOf(lowerQuery, start);
      if (index == -1) {
        spans.add(TextSpan(text: text.substring(start), style: style));
        break;
      }
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index), style: style));
      }
      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: style.copyWith(
          backgroundColor: const Color(0xFF2D6A4F).withOpacity(0.2),
          color: const Color(0xFF2D6A4F),
          fontWeight: FontWeight.w700,
        ),
      ));
      start = index + query.length;
    }

    return RichText(
      text: TextSpan(children: spans),
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.clip,
    );
  }
}
