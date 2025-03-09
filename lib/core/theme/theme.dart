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
      primaryColor: kPrimaryColor,
      // secondaryHeaderColor: Colors.black,
      brightness: Brightness.light,
      scaffoldBackgroundColor: kLightColor,
      textTheme: lightTextTheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        titleTextStyle: lightTextTheme.titleMedium,
        backgroundColor: kLightColor,
        iconTheme: const IconThemeData(color: kBlackColor),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: kPrimaryColor, // Cursor color
        selectionColor:
            kPrimaryColor.withOpacity(0.4), // Text selection highlight color
        selectionHandleColor:
            kPrimaryColor, // Handle color (dragging selection handles)
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: lightTextTheme.labelMedium,
        labelStyle: lightTextTheme.labelLarge,
        floatingLabelAlignment: FloatingLabelAlignment.start,
        activeIndicatorBorder: const BorderSide(),
        filled: true,
        fillColor: kWhiteColor,
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
          borderSide: BorderSide(color: kRedColor), // Red border for errors
        ),
        disabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.transparent), // Invisible border
        ),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: kBlackColor,
        textColor: kBlackColor,
        tileColor: kWhiteColor,
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
          backgroundColor: kBlackColor,
          foregroundColor: kWhiteColor,
          textStyle: TextStyle(
            fontFamily: lightTextTheme.labelLarge!.fontFamily,
            fontSize: lightTextTheme.labelLarge!.fontSize,
            fontWeight: lightTextTheme.labelLarge!.fontWeight,
          ),
        ),
      ),
      dialogBackgroundColor: kWhiteColor,
      datePickerTheme: DatePickerThemeData(
        backgroundColor: kWhiteColor,
        confirmButtonStyle: TextButton.styleFrom(foregroundColor: kBlackColor),
        cancelButtonStyle: TextButton.styleFrom(foregroundColor: kBlackColor),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: kWhiteColor,
        confirmButtonStyle: TextButton.styleFrom(foregroundColor: kBlackColor),
        cancelButtonStyle: TextButton.styleFrom(foregroundColor: kBlackColor),
        dayPeriodColor: kWhiteColor,
        dialHandColor: kBlackColor,
        dialTextColor: kBlackColor,
        hourMinuteColor: kWhiteColor,
        dayPeriodTextColor: kBlackColor,
        hourMinuteTextColor: kBlackColor,
        entryModeIconColor: kBlackColor,
        dialBackgroundColor: kWhiteColor,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: kWhiteColor,
        labelStyle: lightTextTheme.labelMedium,
        selectedColor: kPrimaryColor,
        secondaryLabelStyle:
            lightTextTheme.labelMedium!.copyWith(color: kWhiteColor),
        iconTheme: const IconThemeData(
          color: kBlackColor,
        ),
        checkmarkColor: kWhiteColor,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: kBlackColor,
        unselectedItemColor: kWhiteColor,
        selectedItemColor: kPrimaryColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      primaryColor: kPrimaryColor,
      // secondaryHeaderColor: Colors.black,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: kDarkColor,
      textTheme: darkTextTheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        titleTextStyle: darkTextTheme.titleMedium,
        backgroundColor: kDarkColor,
        iconTheme: const IconThemeData(color: kWhiteColor),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: kPrimaryColor, // Cursor color
        selectionColor:
            kPrimaryColor.withOpacity(0.4), // Text selection highlight color
        selectionHandleColor:
            kPrimaryColor, // Handle color (dragging selection handles)
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: darkTextTheme.labelMedium,
        labelStyle: darkTextTheme.labelLarge,
        floatingLabelAlignment: FloatingLabelAlignment.start,
        activeIndicatorBorder: const BorderSide(),
        filled: true,
        fillColor: kBlackColor,
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
          borderSide: BorderSide(color: kRedColor), // Red border for errors
        ),
        disabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.transparent), // Invisible border
        ),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: kWhiteColor,
        textColor: kWhiteColor,
        tileColor: kBlackColor,
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
          backgroundColor: kWhiteColor,
          foregroundColor: kBlackColor,
          textStyle: TextStyle(
            fontFamily: lightTextTheme.labelLarge!.fontFamily,
            fontSize: lightTextTheme.labelLarge!.fontSize,
            fontWeight: lightTextTheme.labelLarge!.fontWeight,
          ),
        ),
      ),
      dialogBackgroundColor: kBlackColor,
      datePickerTheme: DatePickerThemeData(
        backgroundColor: kBlackColor,
        confirmButtonStyle: TextButton.styleFrom(foregroundColor: kWhiteColor),
        cancelButtonStyle: TextButton.styleFrom(foregroundColor: kWhiteColor),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: kBlackColor,
        confirmButtonStyle: TextButton.styleFrom(foregroundColor: kWhiteColor),
        cancelButtonStyle: TextButton.styleFrom(foregroundColor: kWhiteColor),
        dayPeriodColor: kBlackColor,
        dialHandColor: kWhiteColor,
        dialTextColor: kWhiteColor,
        hourMinuteColor: kBlackColor,
        dayPeriodTextColor: kWhiteColor,
        hourMinuteTextColor: kWhiteColor,
        entryModeIconColor: kWhiteColor,
        dialBackgroundColor: kBlackColor,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: kBlackColor,
        labelStyle: darkTextTheme.labelMedium,
        selectedColor: kPrimaryColor,
        secondaryLabelStyle: darkTextTheme.labelMedium,
        iconTheme: const IconThemeData(
          color: kWhiteColor,
        ),
        checkmarkColor: kBlackColor,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: kBlackColor,
        unselectedItemColor: kWhiteColor,
        selectedItemColor: kPrimaryColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
