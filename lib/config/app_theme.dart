import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Vision 2030 inspired refined colors - Modern palette
  static const Color primaryGreen =
      Color(0xFF0CA678); // More vibrant teal-green
  static const Color secondaryGreen = Color(0xFF12B886); // Brighter accent
  static const Color successGreen = Color(0xFF40C057); // Success green color
  static const Color accentGold = Color(0xFFE8B554); // Refined gold
  static const Color white = Colors.white;
  static const Color black = Color(0xFF212529); // Deeper black for contrast
  static const Color lightGrey = Color(0xFFF8F9FA); // Modern light grey
  static const Color mediumGrey = Color(0xFFE9ECEF); // Softer medium grey

  // Additional modern UI colors
  static const Color subtleGrey = Color(0xFFDEE2E6); // For dividers and strokes
  static const Color darkGrey = Color(0xFF495057); // For secondary text

  // AI-themed semantic colors - More vibrant
  static const Color aiBlue = Color(0xFF339AF0); // Modern intelligent blue
  static const Color aiAmber = Color(0xFFFFAB2E); // Brighter knowledge amber
  static const Color aiSoftPurple =
      Color(0xFFD0BFFF); // Modern innovation purple
  static const Color aiBgOverlay = Color(0x0A0CA678); // Updated subtle tint
  static const Color aiGreen = Color(0xFF20C997); // AI success indicator

  // Modern Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryGreen, Color(0xFF099268)],
    stops: [0.0, 1.0],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentGold, Color(0xFFFFD166)],
    stops: [0.0, 1.0],
  );

  // Modern frosted glass effect gradient
  static LinearGradient get frostedGlassGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          white.withOpacity(0.8),
          white.withOpacity(0.6),
        ],
        stops: const [0.0, 1.0],
      );

  // Modern AI gradient
  static const LinearGradient aiGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [aiBlue, aiSoftPurple],
    stops: [0.0, 1.0],
  );

  // Modern shadows and elevation
  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: black.withOpacity(0.03),
          offset: const Offset(0, 2),
          blurRadius: 10,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: black.withOpacity(0.01),
          offset: const Offset(0, 1),
          blurRadius: 5,
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> get mediumShadow => [
        BoxShadow(
          color: black.withOpacity(0.06),
          offset: const Offset(0, 5),
          blurRadius: 15,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: black.withOpacity(0.03),
          offset: const Offset(0, 2),
          blurRadius: 8,
          spreadRadius: 0,
        ),
      ];

  // Modern layered shadow for more depth
  static List<BoxShadow> get layeredShadow => [
        BoxShadow(
          color: black.withOpacity(0.04),
          offset: const Offset(0, 10),
          blurRadius: 20,
          spreadRadius: -2,
        ),
        BoxShadow(
          color: black.withOpacity(0.06),
          offset: const Offset(0, 3),
          blurRadius: 6,
          spreadRadius: -1,
        ),
      ];

  // Subtle inner shadow for pressed elements
  static List<BoxShadow> get innerShadow => [
        BoxShadow(
          color: black.withOpacity(0.05),
          offset: const Offset(0, 2),
          blurRadius: 4,
          spreadRadius: -1,
        ),
      ];

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 180);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 450);

  // Spring animations for more natural motion
  static const Curve modernEasing = Curves.easeOutCubic;
  static const Curve bouncyEasing = Curves.elasticOut;

  // Modern theme data
  static ThemeData get lightTheme {
    return ThemeData.light().copyWith(
      primaryColor: primaryGreen,
      colorScheme: const ColorScheme.light(
        primary: primaryGreen,
        secondary: secondaryGreen,
        surface: white,
        background: white,
        error: Colors.redAccent,
        onPrimary: white,
        onSecondary: white,
        onSurface: black,
        onBackground: black,
        onError: white,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: lightGrey,
      appBarTheme: AppBarTheme(
        backgroundColor: white,
        foregroundColor: primaryGreen,
        centerTitle: true,
        elevation: 0,
        shadowColor: black.withOpacity(0.1),
        titleTextStyle: GoogleFonts.cairo(
          color: primaryGreen,
          fontWeight: FontWeight.w600,
          fontSize: 20,
          letterSpacing: -0.3,
        ),
        iconTheme: const IconThemeData(
          color: primaryGreen,
          size: 22,
        ),
      ),
      textTheme: GoogleFonts.cairoTextTheme(
        ThemeData.light().textTheme,
      )
          .apply(
            bodyColor: black,
            displayColor: black,
          )
          .copyWith(
            headlineMedium: GoogleFonts.cairo(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
              height: 1.3,
            ),
            titleLarge: GoogleFonts.cairo(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
              height: 1.3,
            ),
            titleMedium: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
              height: 1.3,
            ),
            bodyLarge: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.1,
              height: 1.5,
            ),
            bodyMedium: GoogleFonts.cairo(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 0,
              height: 1.4,
            ),
          ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.disabled)) {
              return primaryGreen.withOpacity(0.3);
            }
            return primaryGreen;
          }),
          foregroundColor: MaterialStateProperty.all(white),
          elevation: MaterialStateProperty.resolveWith<double>((states) {
            if (states.contains(MaterialState.pressed)) return 0;
            if (states.contains(MaterialState.hovered)) return 3;
            return 1;
          }),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          overlayColor: MaterialStateProperty.all(white.withOpacity(0.1)),
          textStyle: MaterialStateProperty.all(
            GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
            ),
          ),
          animationDuration: mediumAnimation,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(primaryGreen),
          overlayColor:
              MaterialStateProperty.all(primaryGreen.withOpacity(0.05)),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          textStyle: MaterialStateProperty.all(
            GoogleFonts.cairo(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
            ),
          ),
          animationDuration: shortAnimation,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(primaryGreen),
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.pressed)) {
              return primaryGreen.withOpacity(0.05);
            }
            return white;
          }),
          side: MaterialStateProperty.all(
            const BorderSide(color: primaryGreen, width: 1.5),
          ),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          textStyle: MaterialStateProperty.all(
            GoogleFonts.cairo(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
            ),
          ),
          animationDuration: shortAnimation,
        ),
      ),
      cardTheme: CardTheme(
        color: white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: mediumGrey,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: mediumGrey,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: primaryGreen,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 1,
          ),
        ),
        hintStyle: GoogleFonts.cairo(
          color: black.withOpacity(0.5),
          fontSize: 14,
        ),
        labelStyle: GoogleFonts.cairo(
          color: black.withOpacity(0.7),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryGreen,
        foregroundColor: white,
        elevation: 2,
        highlightElevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: white,
        selectedItemColor: primaryGreen,
        unselectedItemColor: Color(0xFF9E9E9E),
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: 8,
      ),
      dividerTheme: DividerThemeData(
        color: mediumGrey.withOpacity(0.5),
        thickness: 1,
        space: 24,
      ),
      iconTheme: const IconThemeData(
        color: primaryGreen,
        size: 24,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      tabBarTheme: TabBarTheme(
        labelColor: primaryGreen,
        unselectedLabelColor: black.withOpacity(0.5),
        indicatorSize: TabBarIndicatorSize.label,
        indicator: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: primaryGreen,
              width: 2.0,
            ),
          ),
        ),
        labelStyle: GoogleFonts.cairo(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.cairo(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: black.withOpacity(0.8),
        contentTextStyle: GoogleFonts.cairo(
          color: white,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Helper methods for styling
  static BoxDecoration get cardDecoration => BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: softShadow,
      );

  static BoxDecoration get elevatedCardDecoration => BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: mediumShadow,
      );

  static BoxDecoration get gradientCardDecoration => BoxDecoration(
        gradient: primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: softShadow,
      );

  static BoxDecoration get aiBackgroundDecoration => BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: softShadow,
        border: Border.all(color: aiSoftPurple.withOpacity(0.3), width: 1),
      );
}
