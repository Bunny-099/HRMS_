import 'package:flutter/material.dart';

class GlassTheme {
  // Colors
  static const Color bgDarkStart = Color(0xFF090D16);
  static const Color bgDarkEnd = Color(0xFF111827);
  static const Color accentGlow = Color(0xFF3B82F6);
  static const Color violetGlow = Color(0xFF8B5CF6);
  static const Color textWhite = Colors.white;
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color glassWhite = Colors.white10;
  static const Color glassBorder = Colors.white24;

  // Semantic Colors for Status
  static const Color success = Color(0xFF10B981); // Emerald-ish
  static const Color successAccent = Color(0xFF34D399);
  static const Color error = Color(0xFFF43F5E); // Rose-ish
  static const Color errorAccent = Color(0xFFFB7185);
  static const Color warning = Color(0xFFF59E0B); // Amber-ish
  static const Color warningAccent = Color(0xFFFBBF24);

  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: textWhite,
    letterSpacing: -0.5,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 15,
    color: textMuted,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14,
    color: textWhite,
  );
}
