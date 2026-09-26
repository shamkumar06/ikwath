import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Ministry of Ayush (Government of India) Official Design System & Modern Theme
/// Inspired by the official portal (ayush.gov.in) with modern glassmorphic,
/// high-legibility, and governmental authority styling.
class AppTheme {
  // ── Ministry of Ayush Brand Palette ──────────────────────────────────────
  // Authentic Ayush Radiant Saffron / Kesar
  static const Color primary = Color(0xFFE65100);       
  static const Color primaryDark = Color(0xFFBF360C);
  static const Color primaryDeep = Color(0xFF8C2500);
  static const Color primaryLight = Color(0xFFFFF3E0);

  // Official Ministry Royal Blue & Indian Government Navy (ayush.gov.in banner)
  static const Color ayushBlue = Color(0xFF0B4F9C);
  static const Color ayushNavy = Color(0xFF072A5C);
  static const Color ayushBlueDark = Color(0xFF051C3E);
  static const Color ayushBlueLight = Color(0xFFEBF3FC);
  static const Color ayushBlueBorder = Color(0xFFB8D5F8);
  static const Color ayushAccentBlue = Color(0xFF1976D2);

  // Ayurvedic Botanical / Tulsi Green (Safe states, health, herbal extraction)
  static const Color green = Color(0xFF15803D);         
  static const Color greenBg = Color(0xFFF0FDF4);
  static const Color greenBorder = Color(0xFF86EFAC);

  // Saffron / Haldi Amber (PID Heating & Dynamic stages)
  static const Color amber = Color(0xFFD97706);
  static const Color amberBg = Color(0xFFFEF3C7);
  static const Color amberBorder = Color(0xFFFDE68A);

  // Critical Alert / Emergency Red
  static const Color red = Color(0xFFDC2626);
  static const Color redBg = Color(0xFFFEE2E2);
  static const Color redBorder = Color(0xFFFCA5A5);

  // Traditional Ayurvedic Kashayam / Decoction Brown
  static const Color herbalBrown = Color(0xFF78350F);
  static const Color decoction = Color(0xFF5A2A0C);

  // Indian National Tricolour Accent Ribbons
  static const Color tricolorSaffron = Color(0xFFFF9933);
  static const Color tricolorWhite = Color(0xFFFFFFFF);
  static const Color tricolorGreen = Color(0xFF138808);

  // ── Light Surface Tokens (Official Ayush Portal Look) ────────────────────
  static const Color bgLight = Color(0xFFF6F8FC);       // Modern portal slate-white
  static const Color cardLight = Color(0xFFFFFFFF);     // Pure card white
  static const Color borderLight = Color(0xFFE2E8F0);   // Subtle divider border
  static const Color textMainLight = Color(0xFF0F172A); // High-contrast navy-charcoal
  static const Color textMutedLight = Color(0xFF64748B);// Balanced subtitle gray

  // ── Dark Surface Tokens (Dignified Midnight Ayush Navy) ─────────────────
  static const Color bgDark = Color(0xFF080E1E);        // Midnight Ayush Navy
  static const Color cardDark = Color(0xFF0F1A38);      // Deep blue-gray card
  static const Color sidebarDark = Color(0xFF0A1329);   // Deep sidebar navy
  static const Color borderDark = Color(0xFF1E3163);    // Subtle navy border
  static const Color textMainDark = Color(0xFFF8FAFC);   // Crisp white
  static const Color textMutedDark = Color(0xFF94A3B8);  // Slate muted text

  // ── Light Theme ──────────────────────────────────────────────────────────
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primary,
        onPrimary: Colors.white,
        secondary: ayushBlue,
        onSecondary: Colors.white,
        tertiary: green,
        surface: cardLight,
        onSurface: textMainLight,
        outline: borderLight,
      ),
      scaffoldBackgroundColor: bgLight,
      textTheme: GoogleFonts.interTextTheme().apply(
        bodyColor: textMainLight,
        displayColor: textMainLight,
      ),
      cardTheme: CardThemeData(
        color: cardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: borderLight),
        ),
      ),
      dividerColor: borderLight,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: textMainLight,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: textMainLight,
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: Colors.white,
        selectedIconTheme: const IconThemeData(color: primary, size: 22),
        unselectedIconTheme: const IconThemeData(color: textMutedLight, size: 22),
        selectedLabelTextStyle: GoogleFonts.inter(
          color: primary,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        unselectedLabelTextStyle: GoogleFonts.inter(
          color: textMutedLight,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        indicatorColor: primaryLight,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ayushBlue,
          side: const BorderSide(color: ayushBlueBorder),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // ── Dark Theme ───────────────────────────────────────────────────────────
  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        onPrimary: Colors.white,
        secondary: ayushAccentBlue,
        onSecondary: Colors.white,
        tertiary: green,
        surface: cardDark,
        onSurface: textMainDark,
        outline: borderDark,
      ),
      scaffoldBackgroundColor: bgDark,
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: textMainDark,
        displayColor: textMainDark,
      ),
      cardTheme: CardThemeData(
        color: cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: borderDark),
        ),
      ),
      dividerColor: borderDark,
      appBarTheme: AppBarTheme(
        backgroundColor: cardDark,
        foregroundColor: textMainDark,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: textMainDark,
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: sidebarDark,
        selectedIconTheme: const IconThemeData(color: primary, size: 22),
        unselectedIconTheme: const IconThemeData(color: textMutedDark, size: 22),
        selectedLabelTextStyle: GoogleFonts.inter(
          color: primary,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        unselectedLabelTextStyle: GoogleFonts.inter(
          color: textMutedDark,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        indicatorColor: const Color(0x33E65100),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF60A5FA),
          side: const BorderSide(color: Color(0xFF1E3A8A)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
