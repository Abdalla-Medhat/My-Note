import 'package:flutter/material.dart';

class MyThemes {
  static final lightTheme = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      surface: Color(0xfffaf9fa),
      surfaceBright: Color(0xfffaf9fa),
      surfaceDim: Color(0xffdbdadb),
      surfaceContainerLowest: Color(0xfffaf9fa),
      surfaceContainerLow: Color(0xfff5f3f4),
      surfaceContainer: Color(0xffefedee),
      surfaceContainerHigh: Color(0xffe9e8e9),
      surfaceContainerHighest: Color(0xffe3e2e3),
      onSurface: Color(0xff1b1c1d),
      onSurfaceVariant: Color(0xff434653),
      inverseSurface: Color(0xff303031),
      onInverseSurface: Color(0xfff2f0f1),
      outline: Color(0xff737784),
      outlineVariant: Color(0xffc3c6d5),
      surfaceTint: Color(0xff2259bf),
      primary: Color(0xff094cb2),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff3366cc),
      onPrimaryContainer: Color(0xffe7ebff),
      inversePrimary: Color(0xffb1c5ff),
      secondary: Color(0xff5a5f63),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffdfe3e8),
      onSecondaryContainer: Color(0xff606569),
      tertiary: Color(0xff6d5e00),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffbfab49),
      onTertiaryContainer: Color(0xff4a3f00),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      primaryFixed: Color(0xffd9e2ff),
      primaryFixedDim: Color(0xffb1c5ff),
      onPrimaryFixed: Color(0xff001946),
      onPrimaryFixedVariant: Color(0xff00419d),
      secondaryFixed: Color(0xffdfe3e8),
      secondaryFixedDim: Color(0xffc2c7cc),
      onSecondaryFixed: Color(0xff171c20),
      onSecondaryFixedVariant: Color(0xff42474b),
      tertiaryFixed: Color(0xfff9e37a),
      tertiaryFixedDim: Color(0xffdcc661),
      onTertiaryFixed: Color(0xff211b00),
      onTertiaryFixedVariant: Color(0xff524600),
    ),

    // Text Theme
    textTheme: const TextTheme(
      // headline-lg
      headlineLarge: TextStyle(
        fontFamily: 'Noto Serif',
        fontSize: 32,
        fontWeight: FontWeight.w700, // '700'
        height: 1.2, // lineHeight
      ),
      // headline-md
      headlineMedium: TextStyle(
        fontFamily: 'Noto Serif',
        fontSize: 24,
        fontWeight: FontWeight.w600, // '600'
        height: 1.3,
      ),
      // body-md
      bodyMedium: TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w400, // '400'
        height: 1.6,
      ),
      // label-md
      labelMedium: TextStyle(
        fontFamily: 'Public Sans',
        fontSize: 14,
        fontWeight: FontWeight.w500, // '500'
        height: 1.4,
      ),
    ),

    // Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xff3366cc),
        foregroundColor: Colors.white,
        minimumSize: Size(88, 45),
        maximumSize: Size(200, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Standard Radius (0.25rem)
        ),
      ),
    ),

    // Cards Theme
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Large Radius (0.5rem)
      ),
    ),

    // Text Field Theme
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(color: Color(0xff737784).withAlpha(60)),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xff737784).withAlpha(60),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8), // Standard Radius (0.25rem)
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: Color(0xff737784).withAlpha(60),
          width: 1,
        ),
      ),
    ),

    // AppBar Theme
    appBarTheme: const AppBarTheme(
      toolbarHeight: 60,
      backgroundColor: Color(0xfffaf9fa),
      foregroundColor: Color(0xff094cb2),
      titleTextStyle: TextStyle(color: Color(0xff094cb2)),
      elevation: 1,
      shadowColor: Color(0xfff5f3f4),
      surfaceTintColor: Colors.transparent,
    ),
  );

  static final darkTheme = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      surface: Color(0xff121314),
      surfaceBright: Color(0xff38393a),
      surfaceDim: Color(0xff121314),
      surfaceContainerLowest: Color(0xff0d0e0f),
      surfaceContainerLow: Color(0xff1b1c1d),
      surfaceContainer: Color(0xff1f2021),
      surfaceContainerHigh: Color(0xff292a2b),
      surfaceContainerHighest: Color(0xff343536),
      onSurface: Color(0xffe3e2e3),
      onSurfaceVariant: Color(0xffc3c6d5),
      inverseSurface: Color(0xffe3e2e3),
      onInverseSurface: Color(0xff303031),
      outline: Color(0xff8d909e),
      outlineVariant: Color(0xff434653),
      surfaceTint: Color(0xffb1c5ff),
      primary: Color(0xffb1c5ff),
      onPrimary: Color(0xff002c70),
      primaryContainer: Color(0xff3366cc),
      onPrimaryContainer: Color(0xffe7ebff),
      inversePrimary: Color(0xff2259bf),
      secondary: Color(0xffc2c7cc),
      onSecondary: Color(0xff2c3135),
      secondaryContainer: Color(0xff42474b),
      onSecondaryContainer: Color(0xffb1b6ba),
      tertiary: Color(0xffdcc661),
      onTertiary: Color(0xff393000),
      tertiaryContainer: Color(0xffbfab49),
      onTertiaryContainer: Color(0xff4a3f00),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      primaryFixed: Color(0xffd9e2ff),
      primaryFixedDim: Color(0xffb1c5ff),
      onPrimaryFixed: Color(0xff001946),
      onPrimaryFixedVariant: Color(0xff00419d),
      secondaryFixed: Color(0xffdfe3e8),
      secondaryFixedDim: Color(0xffc2c7cc),
      onSecondaryFixed: Color(0xff171c20),
      onSecondaryFixedVariant: Color(0xff42474b),
      tertiaryFixed: Color(0xfff9e37a),
      tertiaryFixedDim: Color(0xffdcc661),
      onTertiaryFixed: Color(0xff211b00),
      onTertiaryFixedVariant: Color(0xff524600),
    ),

    textTheme: const TextTheme(
      // headline-lg
      headlineLarge: TextStyle(
        fontFamily: 'Noto Serif',
        fontSize: 32,
        fontWeight: FontWeight.w700, // '700'
        height: 1.2, // lineHeight
      ),
      // headline-md
      headlineMedium: TextStyle(
        fontFamily: 'Noto Serif',
        fontSize: 24,
        fontWeight: FontWeight.w600, // '600'
        height: 1.3,
      ),
      // body-md
      bodyMedium: TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w400, // '400'
        height: 1.6,
      ),
      // label-md
      labelMedium: TextStyle(
        fontFamily: 'Public Sans',
        fontSize: 14,
        fontWeight: FontWeight.w500, // '500'
        height: 1.4,
      ),
    ),

    // Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xff094cb2),
        foregroundColor: Colors.white,
        minimumSize: Size(88, 45),
        maximumSize: Size(200, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Standard Radius (0.25rem)
        ),
      ),
    ),

    // Cards Theme
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Large Radius (0.5rem)
      ),
    ),

    // Text Field Theme
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(color: Color(0xff737784).withAlpha(60)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8), // Standard Radius (0.25rem)
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: Color(0xff737784).withAlpha(60),
          width: 1,
        ),
      ),
    ),

    // AppBar Theme
    appBarTheme: const AppBarTheme(
      toolbarHeight: 60,
      backgroundColor: Color(0xff121314),
      foregroundColor: Color(0xffb1c5ff),
      titleTextStyle: TextStyle(color: Color(0xffb1c5ff)),
      elevation: 1,
      shadowColor: Color(0xff1b1c1d),
      surfaceTintColor: Colors.transparent,
    ),
  );
}
