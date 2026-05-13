import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // ── Colour scheme ────────────────────────────────────────────────────
      colorScheme: ColorScheme.fromSeed(
        seedColor: YgeiaColors.accent,
        primary: YgeiaColors.accent,
        surface: YgeiaColors.bgBase,
        brightness: Brightness.light,
      ).copyWith(
        primary: YgeiaColors.accent,
        onPrimary: YgeiaColors.white,
        surface: YgeiaColors.bgBase,
        onSurface: YgeiaColors.textPrimary,
        secondary: YgeiaColors.accentSecondary,
        onSecondary: YgeiaColors.white,
        outline: YgeiaColors.divider,
      ),

      scaffoldBackgroundColor: YgeiaColors.bgBase,

      // ── AppBar ───────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: YgeiaColors.bgBase,
        foregroundColor: YgeiaColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        shadowColor: YgeiaColors.divider,
        centerTitle: true,
        titleTextStyle: GoogleFonts.fraunces(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: YgeiaColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: YgeiaColors.textPrimary),
      ),

      // ── NavigationBar ────────────────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: YgeiaColors.bgCard,
        indicatorColor: YgeiaColors.accentSoft,
        elevation: 0,
        shadowColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: YgeiaColors.accent,
            );
          }
          return GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: YgeiaColors.textMuted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: YgeiaColors.accent, size: 22);
          }
          return const IconThemeData(color: YgeiaColors.textMuted, size: 22);
        }),
      ),

      // ── Divider ──────────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: YgeiaColors.divider,
        space: 1,
        thickness: 1,
      ),

      // ── Card ─────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: YgeiaColors.bgCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── Input ────────────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: YgeiaColors.bgCardElevated,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: YgeiaColors.accent, width: 1.5),
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: 14,
          color: YgeiaColors.textMuted,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),

      // ── ElevatedButton ───────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: YgeiaColors.accent,
          foregroundColor: YgeiaColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── TextButton ───────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: YgeiaColors.accent,
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── Switch ───────────────────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return YgeiaColors.white;
          }
          return YgeiaColors.textMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return YgeiaColors.accent;
          }
          return YgeiaColors.divider;
        }),
      ),

      // ── Text theme (base) ────────────────────────────────────────────────
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.fraunces(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: YgeiaColors.textPrimary,
        ),
        headlineLarge: GoogleFonts.fraunces(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: YgeiaColors.textPrimary,
        ),
        headlineMedium: GoogleFonts.fraunces(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: YgeiaColors.textPrimary,
        ),
        headlineSmall: GoogleFonts.fraunces(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: YgeiaColors.textPrimary,
        ),
        titleLarge: GoogleFonts.fraunces(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: YgeiaColors.textPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 15,
          height: 1.6,
          color: YgeiaColors.textPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          height: 1.5,
          color: YgeiaColors.textPrimary,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 13,
          color: YgeiaColors.textSecondary,
          height: 1.5,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: YgeiaColors.textMuted,
        ),
      ),
    );
  }
}
