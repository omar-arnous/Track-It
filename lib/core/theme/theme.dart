import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trackit/core/constants/colors.dart';

class TrackItTheme {
  static TextTheme lightTextTheme = TextTheme(
    displayLarge: GoogleFonts.montserrat(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: kBlackColor,
    ), // Large headers (app title)
    titleLarge: GoogleFonts.montserrat(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: kBlackColor,
    ), // Section headers
    titleMedium: GoogleFonts.montserrat(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: kBlackColor,
    ), // Subheaders
    bodyLarge: GoogleFonts.montserrat(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: kBlackColor,
    ), // Main body text
    bodyMedium: GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: kBlackColor,
    ), // Secondary body text
    bodySmall: GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: kBlackColor,
    ), // Hints & small text
    labelLarge: GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: kBlackColor,
    ), // Buttons & labels
    labelMedium: GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: kBlackColor,
    ), // Smaller buttons & captions
  );

  static TextTheme darkTextTheme = TextTheme(
    displayLarge: GoogleFonts.montserrat(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: kWhiteColor,
    ), // Large headers (app title)
    titleLarge: GoogleFonts.montserrat(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: kWhiteColor,
    ), // Section headers
    titleMedium: GoogleFonts.montserrat(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: kWhiteColor,
    ), // Subheaders
    bodyLarge: GoogleFonts.montserrat(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: kWhiteColor,
    ), // Main body text
    bodyMedium: GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: kWhiteColor,
    ), // Secondary body text
    bodySmall: GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: kWhiteColor,
    ), // Hints & small text
    labelLarge: GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: kWhiteColor,
    ), // Buttons & labels
    labelMedium: GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: kWhiteColor,
    ), // Smaller buttons & captions
  );

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      // secondaryHeaderColor: Colors.black,
      brightness: Brightness.light,
      scaffoldBackgroundColor: kLightColor,
      textTheme: lightTextTheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        titleTextStyle: lightTextTheme.titleMedium,
        color: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: lightTextTheme.labelMedium,
        labelStyle: lightTextTheme.labelLarge,
        floatingLabelAlignment: FloatingLabelAlignment.start,
        activeIndicatorBorder: const BorderSide(),
        filled: true,
        fillColor: Colors.grey[200],
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.transparent), // Invisible border
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.transparent), // Invisible border
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.transparent), // Invisible border
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.red), // Red border for errors
        ),
        disabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.transparent), // Invisible border
        ),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: Colors.black,
        textColor: Colors.black,
        tileColor: Color(0xFFEEEEEE),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          textStyle: TextStyle(
            fontFamily: lightTextTheme.labelLarge!.fontFamily,
            fontSize: lightTextTheme.labelLarge!.fontSize,
            fontWeight: lightTextTheme.labelLarge!.fontWeight,
          ),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }

  // static ThemeData dark() {}
}
