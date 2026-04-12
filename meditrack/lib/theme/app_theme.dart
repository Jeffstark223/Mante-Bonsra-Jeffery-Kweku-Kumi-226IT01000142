import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF4C6EF5),

    scaffoldBackgroundColor: const Color(0xFFF7F9FC),

    textTheme: GoogleFonts.poppinsTextTheme(),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
    ),

    colorScheme: ColorScheme.light(
      primary: const Color(0xFF4C6EF5),
      secondary: const Color(0xFF748FFC),
      background: const Color(0xFFF7F9FC),
    ),
  );
}