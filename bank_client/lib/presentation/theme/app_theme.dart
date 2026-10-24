import 'package:flutter/material.dart';

class AppTheme {
  // Цветовая палитра из Figma
  static const Color primaryBlue = Color(0xFF1E7CF1);
  static const Color lightBackground = Color(0xFFEEF5FD);
  static const Color darkBackground = Color(0xFF0D1424);
  static const Color fieldBackground = Color(0xFF1F1B24); // Или светлый вариант для инпутов
  static const Color cardSurfaceDark = Color(0xFF1F1B24);
  static const Color successGreen = Color(0xFF28A745);
  static const Color expenseRed = Color(0xFFD32F2F);
  static const Color mainTextDark = Color(0xFF1A2B42);

  // 1. Светлая тема
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightBackground,
    colorScheme: ColorScheme.fromSeed(seedColor: primaryBlue, primary: primaryBlue, brightness: Brightness.light),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryBlue,
      foregroundColor: Colors.white,
      centerTitle: true,
      titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
    textTheme: const TextTheme(
      // H1 Title - Inter Bold 28px
      displayLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: mainTextDark),
      // Input Text / Body
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600), // Card Name
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal), // Main Text
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFE0E8F0), // Более темный серый/голубоватый цвет плашек из Figma!
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
      labelStyle: const TextStyle(color: Colors.black54, fontSize: 20),
      floatingLabelStyle: const TextStyle(color: primaryBlue, fontSize: 16, fontWeight: FontWeight.bold),

      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primaryBlue, width: 1.5),
      ),
    ),
  );

  // 2. Темная тема (по фигмо-стилю)
  // 2. Темная тема (по фигмо-стилю)
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackground,
    colorScheme: ColorScheme.fromSeed(seedColor: primaryBlue, brightness: Brightness.dark, primary: primaryBlue, secondary: successGreen),
    cardTheme: CardThemeData(
      color: cardSurfaceDark,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    appBarTheme: const AppBarTheme(backgroundColor: cardSurfaceDark, foregroundColor: Colors.white, centerTitle: true),

    // Выравниваем размеры с темной темой, чтобы они не были огромными!
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white), // Было 36 -> стало 28
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.white70), // Было 20 -> стало 16
      bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
      bodySmall: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white60),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: fieldBackground,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
      labelStyle: const TextStyle(color: Colors.white60, fontSize: 20),
      floatingLabelStyle: const TextStyle(color: primaryBlue, fontSize: 16, fontWeight: FontWeight.bold),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primaryBlue, width: 1.5),
      ),
    ),
  );
}
