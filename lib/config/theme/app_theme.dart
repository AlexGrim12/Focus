import 'package:flutter/material.dart';
// importar google_fonts
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final ColorScheme colorScheme =
        ColorScheme.fromSeed(seedColor: Colors.amber);
    return ThemeData(
      brightness: Brightness.light,
      colorSchemeSeed: Colors.amber,
      // cambiar la fuente predeterminada
      fontFamily: GoogleFonts.inter().fontFamily,

      scaffoldBackgroundColor: colorScheme.surfaceContainerLow,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surfaceContainerLow,
        elevation: 0,
      ),
    );
  }

  static ThemeData get darkTheme {
    const Color colorS = Colors.amber;
    return ThemeData(
      brightness: Brightness.dark,
      colorSchemeSeed: colorS,
      // cambiar la fuente predeterminada
      fontFamily: GoogleFonts.inter().fontFamily,
      // color del texto

      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        elevation: 0,
      ),
    );
  }
}
