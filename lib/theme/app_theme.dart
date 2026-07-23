import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData get theme {
    final baseTextTheme = GoogleFonts.dmSansTextTheme();
    
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.beigeLight,
      primaryColor: AppColors.mauve,
      
      colorScheme: const ColorScheme.light(
        primary: AppColors.mauve,
        secondary: AppColors.blushDeep,
        surface: AppColors.white,
        error: AppColors.bad,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.text,
      ),

      // Typography
      textTheme: baseTextTheme.copyWith(
        displayLarge: GoogleFonts.playfairDisplay(
          textStyle: baseTextTheme.displayLarge?.copyWith(
            color: AppColors.text,
            fontWeight: FontWeight.w500,
          ),
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          textStyle: baseTextTheme.displayMedium?.copyWith(
            color: AppColors.text,
            fontWeight: FontWeight.w500,
          ),
        ),
        displaySmall: GoogleFonts.playfairDisplay(
          textStyle: baseTextTheme.displaySmall?.copyWith(
            color: AppColors.text,
            fontWeight: FontWeight.w500,
          ),
        ),
        headlineLarge: GoogleFonts.playfairDisplay(
          textStyle: baseTextTheme.headlineLarge?.copyWith(
            color: AppColors.text,
            fontWeight: FontWeight.w500,
          ),
        ),
        headlineMedium: GoogleFonts.playfairDisplay(
          textStyle: baseTextTheme.headlineMedium?.copyWith(
            color: AppColors.text,
            fontWeight: FontWeight.w500,
          ),
        ),
        headlineSmall: GoogleFonts.playfairDisplay(
          textStyle: baseTextTheme.headlineSmall?.copyWith(
            color: AppColors.text,
            fontWeight: FontWeight.w500,
          ),
        ),
        titleLarge: GoogleFonts.playfairDisplay(
          textStyle: baseTextTheme.titleLarge?.copyWith(
            color: AppColors.text,
            fontWeight: FontWeight.w500,
          ),
        ),
        titleMedium: GoogleFonts.playfairDisplay(
          textStyle: baseTextTheme.titleMedium?.copyWith(
            color: AppColors.text,
            fontWeight: FontWeight.w500,
          ),
        ),
        titleSmall: GoogleFonts.playfairDisplay(
          textStyle: baseTextTheme.titleSmall?.copyWith(
            color: AppColors.text,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.text,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.playfairDisplay(
          color: AppColors.text,
          fontSize: 20,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.2,
        ),
        iconTheme: const IconThemeData(color: AppColors.mauve),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.border, width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.mauve,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          textStyle: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 2.0, // 0.2em letter spacing
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.mauve,
          side: const BorderSide(color: AppColors.mauve, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          textStyle: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 2.0,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.beigeLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.mauve, width: 1.5),
        ),
        labelStyle: TextStyle(
          color: AppColors.textMid,
        ),
        hintStyle: TextStyle(
          color: AppColors.textFade,
        ),
        prefixIconColor: AppColors.textLight,
        suffixIconColor: AppColors.textLight,
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.border),
          borderRadius: BorderRadius.circular(4),
        ),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
      ),
    );
  }
}
