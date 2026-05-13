import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class YgeiaTypography {
  YgeiaTypography._();

  // ── Headings — Fraunces (serif) ──────────────────────────────────────────
  static TextStyle get h1 => GoogleFonts.fraunces(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: YgeiaColors.textPrimary,
        height: 1.25,
      );

  static TextStyle get h2 => GoogleFonts.fraunces(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: YgeiaColors.textPrimary,
        height: 1.3,
      );

  static TextStyle get h3 => GoogleFonts.fraunces(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: YgeiaColors.textPrimary,
        height: 1.35,
      );

  static TextStyle get metric => GoogleFonts.fraunces(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: YgeiaColors.textPrimary,
      );

  // ── Body — Inter (sans) ──────────────────────────────────────────────────
  static TextStyle get body => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: YgeiaColors.textPrimary,
        height: 1.6,
      );

  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: YgeiaColors.textSecondary,
        height: 1.5,
      );

  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: YgeiaColors.textMuted,
      );

  static TextStyle get label => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: YgeiaColors.textPrimary,
      );
}
