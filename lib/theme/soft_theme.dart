import 'package:flutter/material.dart';

class SoftTheme {
  static const Color backgroundColor = Color(0xFFFFFACD);  // Light yellow
  static const Color primaryColor = Color(0xFFFF69B4);  // Pink
  static const Color textColor = Color(0xFF8B4513);  // Brown (contrasts well with yellow)
  static const Color hintColor = Color(0xFFD8BFD8);  // Light purple (to complement pink)
  static const Color cardColor = Color(0xFFFFFACD);  // Light yellow
  
  static BoxDecoration get neumorphicContainerStyle => BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.circular(16),
    boxShadow: const [
      BoxShadow(
        color: const Color(0xFFFFFACD),
        offset: Offset(-6, -6),
        blurRadius: 10,
      ),
      BoxShadow(
        color: Color(0xFFA3B1C6),
        offset: Offset(6, 6),
        blurRadius: 10,
      ),
    ],
  );

}