// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

// Project imports:
import 'package:graduation_project/utils/constants/constants.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,

  // Text Theme with ScreenUtil responsive sizing (.sp)
  textTheme: GoogleFonts.robotoTextTheme()
      .apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      )
      .merge(
        TextTheme(
          displayLarge: TextStyle(
            fontSize: 32.sp, // Responsive font size
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          displayMedium: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(
            fontSize: 16.sp,
            color: Colors.grey[300],
          ),
          bodyMedium: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[400],
          ),
          labelLarge: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),

  // Color scheme
  colorScheme: ColorScheme.dark(
    primary: const Color.fromARGB(255, 122, 122, 122),
    secondary: const Color.fromARGB(255, 52, 52, 52),
    tertiary: const Color.fromARGB(255, 47, 47, 47),
    surface: const Color.fromARGB(255, 42, 42, 42),
    inversePrimary: Colors.grey.shade300,
  ),

  scaffoldBackgroundColor: const Color.fromARGB(255, 33, 33, 33),
  primaryColor: const Color.fromARGB(255, 122, 122, 122),

  // Text selection theme
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: deeporange,
    selectionColor: deeporange,
    selectionHandleColor: deeporange,
  ),

  // Input decoration with responsive sizing
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[800],
    contentPadding: EdgeInsets.all(12.w), // Responsive padding
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r), // Responsive radius
      borderSide: BorderSide(color: Colors.grey[700]!),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(color: Colors.grey[700]!),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(color: deeporange, width: 2),
    ),
    labelStyle: TextStyle(
      color: Colors.grey[400],
      fontSize: 14.sp, // Responsive font size
    ),
    hintStyle: TextStyle(
      color: Colors.grey[500],
      fontSize: 14.sp,
    ),
  ),

  // Button themes with responsive sizing
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: deeporange,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 16.h), // Responsive padding
      textStyle: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.orange[500],
      padding: EdgeInsets.all(12.w), // Responsive padding
      textStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),

  // Additional responsive components
  cardTheme: CardTheme(
    elevation: 2,
    margin: EdgeInsets.all(8.r), // Responsive margin
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.r), // Responsive radius
    ),
  ),
);
