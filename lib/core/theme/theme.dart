import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrackItTheme {
  static TextTheme lightTextTheme = TextTheme(
    displayLarge: GoogleFonts.montserrat(
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ), // Large headers (app title)
    titleLarge: GoogleFonts.montserrat(
      fontSize: 24,
      fontWeight: FontWeight.w600,
    ), // Section headers
    titleMedium: GoogleFonts.montserrat(
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ), // Subheaders
    bodyLarge: GoogleFonts.montserrat(
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ), // Main body text
    bodyMedium: GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ), // Secondary body text
    bodySmall: GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ), // Hints & small text
    labelLarge: GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ), // Buttons & labels
    labelMedium: GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ), // Smaller buttons & captions
  );

  static TextTheme darkTextTheme = TextTheme(
    displayLarge: GoogleFonts.montserrat(
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ), // Large headers (app title)
    titleLarge: GoogleFonts.montserrat(
      fontSize: 24,
      fontWeight: FontWeight.w600,
    ), // Section headers
    titleMedium: GoogleFonts.montserrat(
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ), // Subheaders
    bodyLarge: GoogleFonts.montserrat(
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ), // Main body text
    bodyMedium: GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ), // Secondary body text
    bodySmall: GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ), // Hints & small text
    labelLarge: GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ), // Buttons & labels
    labelMedium: GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ), // Smaller buttons & captions
  );

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      textTheme: lightTextTheme,
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: lightTextTheme.labelMedium,
        labelStyle: lightTextTheme.labelLarge,
        // border: const OutlineInputBorder(
        //   borderRadius: BorderRadius.all(
        //     Radius.circular(8),
        //   ),
        // ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  // static ThemeData dark() {}
}
