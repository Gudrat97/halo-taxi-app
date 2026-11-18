import 'package:flutter/material.dart';

const haloYellow = Color(0xFFFFC914);
const haloInk = Color(0xFF17140E);
const haloPaper = Color(0xFFFFFDF6);
const haloGreen = Color(0xFF0E7A4D);

ThemeData haloTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: haloYellow,
    primary: haloInk,
    onPrimary: Colors.white,
    secondary: haloYellow,
    onSecondary: haloInk,
    surface: haloPaper,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: haloPaper,
    appBarTheme: const AppBarTheme(
      backgroundColor: haloYellow,
      foregroundColor: haloInk,
      elevation: 0,
      centerTitle: false,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(54),
        backgroundColor: haloInk,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: haloInk, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD9D3C2), width: 1.5),
      ),
    ),
  );
}
