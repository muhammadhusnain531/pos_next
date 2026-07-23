import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppButtonStyles {
  // Website's .btn-primary (standard elevated)
  static ButtonStyle get primary => ElevatedButton.styleFrom(
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
          letterSpacing: 2.0, // 0.2em
        ),
      );

  // Website's .btn-outline
  static ButtonStyle get outline => OutlinedButton.styleFrom(
        foregroundColor: AppColors.mauve,
        side: const BorderSide(color: AppColors.mauve, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        textStyle: GoogleFonts.dmSans(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 2.0,
        ),
      );

  // Website's .btn.ghost (gray/neutral button)
  static ButtonStyle get ghost => ElevatedButton.styleFrom(
        backgroundColor: AppColors.zincPale,
        foregroundColor: AppColors.text,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        textStyle: GoogleFonts.dmSans(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.8,
        ),
      );

  // Website's .btn.danger (.btn.danger background: var(--bad))
  static ButtonStyle get danger => ElevatedButton.styleFrom(
        backgroundColor: AppColors.bad,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        textStyle: GoogleFonts.dmSans(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.8,
        ),
      );

  // Website's .btn.small
  static ButtonStyle get small => ElevatedButton.styleFrom(
        backgroundColor: AppColors.mauve,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
        ),
        textStyle: GoogleFonts.dmSans(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.5,
        ),
      );
}
