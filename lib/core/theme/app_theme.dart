import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFF0A0E27),
    primaryColor: const Color(0xFF00D9FF),
    primaryColorDark: const Color(0xFF0A0E27),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.roboto(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF00D9FF),
      ),
      displayMedium: GoogleFonts.roboto(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: const Color(0xFFFF006E),
      ),
      titleLarge: GoogleFonts.roboto(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      titleMedium: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.white70,
      ),
      bodyLarge: GoogleFonts.jetBrainsMono(
        fontSize: 14,
        color: const Color(0xFF00D9FF),
      ),
      bodyMedium: GoogleFonts.jetBrainsMono(
        fontSize: 12,
        color: Colors.white60,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF0F1629),
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.roboto(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF00D9FF),
      ),
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF1A1F3A),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(
          color: Color(0xFF00D9FF),
          width: 1.5,
        ),
      ),
    ),
  );

  static const Color neonCyan = Color(0xFF00D9FF);
  static const Color neonMagenta = Color(0xFFFF006E);
  static const Color darkBg = Color(0xFF0A0E27);
  static const Color cardBg = Color(0xFF1A1F3A);
  static const Color accentGray = Color(0xFF2A2F45);
}
