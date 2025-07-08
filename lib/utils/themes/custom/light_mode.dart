// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

// Project imports:
import 'package:graduation_project/utils/constants/constants.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  textTheme: GoogleFonts.robotoTextTheme(
    ThemeData.light().textTheme.copyWith(
          displayLarge: TextStyle(
            fontSize: 32.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          displayMedium: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          bodyLarge: TextStyle(
            fontSize: 16.sp,
            color: Colors.black,
          ),
          bodyMedium: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[800],
          ),
          labelLarge: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
  ),

  // Color scheme with responsive values
  colorScheme: ColorScheme.light(
    inversePrimary: Colors.grey.shade700,
    primary: Colors.orange[800]!,
    secondary: Colors.white,
    surface: Colors.white,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: deeporange,
  ),

  scaffoldBackgroundColor: white,

  // Text selection theme
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: deeporange,
    selectionColor: deeporange,
    selectionHandleColor: deeporange,
  ),

  // Responsive input decoration
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: EdgeInsets.all(12.r), // Responsive padding
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r), // Responsive radius
      borderSide: BorderSide(color: Colors.grey[300]!),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(color: Colors.grey[300]!),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(color: deeporange, width: 2),
    ),
    labelStyle: TextStyle(
      color: Colors.grey[600],
      fontSize: 14.sp, // Responsive font
    ),
    hintStyle: TextStyle(
      color: Colors.grey[500],
      fontSize: 14.sp,
    ),
  ),

  // Responsive button theming
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: deeporange, // Button background color
      foregroundColor: Colors.white, // This controls the text color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 16.h),
      textStyle: TextStyle(
        color: Colors.white, // Explicitly set text color here
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.orange[800],
      padding: EdgeInsets.all(8.r), // Responsive padding
      textStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),

  // Additional responsive components
  cardTheme: CardTheme(
    elevation: 2,
    margin: EdgeInsets.all(8.r),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.r),
    ),
  ),

  dialogTheme: DialogTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.r),
    ),
    contentTextStyle: TextStyle(
      fontSize: 14.sp,
    ),
  ),
);
