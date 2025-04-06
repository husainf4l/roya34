import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  const AppTheme._();

  // Theme constants
  static const double kSpaceXXSmall = 4.0;
  static const double kSpaceXSmall = 8.0;
  static const double kSpaceSmall = 12.0;
  static const double kSpaceMedium = 16.0;
  static const double kSpaceLarge = 24.0;
  static const double kSpaceXLarge = 32.0;
  static const double kSpaceXXLarge = 40.0;

  static const double kBorderRadiusSmall = 8.0;
  static const double kBorderRadiusMedium = 16.0;
  static const double kBorderRadiusLarge = 24.0;
  static const double kBorderRadiusXLarge = 32.0;

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
          Colors.white.withRed(245).withGreen(245).withBlue(245),
          const Color.fromRGBO(255, 255, 255, 0.6),
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
  static const List<BoxShadow> softShadow = [
    BoxShadow(
      color: Color.fromRGBO(33, 37, 41, 0.03),
      offset: Offset(0, 2),
      blurRadius: 10,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color.fromRGBO(33, 37, 41, 0.01),
      offset: Offset(0, 1),
      blurRadius: 5,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> mediumShadow = [
    BoxShadow(
      color: Color.fromRGBO(33, 37, 41, 0.06),
      offset: Offset(0, 5),
      blurRadius: 15,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color.fromRGBO(33, 37, 41, 0.03),
      offset: Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];

  // Modern layered shadow for more depth
  static List<BoxShadow> get layeredShadow => [
        const BoxShadow(
          color: Color.fromRGBO(33, 37, 41, 0.04),
          offset: Offset(0, 10),
          blurRadius: 20,
          spreadRadius: -2,
        ),
        const BoxShadow(
          color: Color.fromRGBO(33, 37, 41, 0.06),
          offset: Offset(0, 3),
          blurRadius: 6,
          spreadRadius: -1,
        ),
      ];

  // Subtle inner shadow for pressed elements
  static List<BoxShadow> get innerShadow => [
        const BoxShadow(
          color: Color.fromRGBO(33, 37, 41, 0.05),
          offset: Offset(0, 2),
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

  // Add theme mode checking
  static bool get isDarkMode => false; // Implement actual dark mode check

  // Add semantic color names
  static Color get primary => aiBlue;
  static Color get secondary => aiSoftPurple;

  // Add consistent opacity values
  static const double kHighEmphasis = 0.87;
  static const double kMediumEmphasis = 0.60;
  static const double kLowEmphasis = 0.38;

  // Modern theme data
  static ThemeData get lightTheme {
    return ThemeData.light().copyWith(
      primaryColor: primaryGreen,
      colorScheme: const ColorScheme.light(
        primary: primaryGreen,
        secondary: secondaryGreen,
        surface: white,
        error: Colors.redAccent,
        onPrimary: white,
        onSecondary: white,
        onSurface: black,
        onError: white,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: lightGrey,
      appBarTheme: AppBarTheme(
        backgroundColor: white,
        foregroundColor: primaryGreen,
        centerTitle: true,
        elevation: 0,
        shadowColor: const Color.fromRGBO(33, 37, 41, 0.1),
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
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryGreen,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: GoogleFonts.cairo(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ).copyWith(
          overlayColor: MaterialStateProperty.all(
            const Color.fromRGBO(12, 166, 120, 0.05),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryGreen,
          backgroundColor: white,
          side: const BorderSide(color: primaryGreen, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: GoogleFonts.cairo(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ).copyWith(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.pressed)) {
              return const Color.fromRGBO(12, 166, 120, 0.05);
            }
            return white;
          }),
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
          borderSide: const BorderSide(
            color: mediumGrey,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
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
          color: const Color.fromRGBO(33, 37, 41, 0.5),
          fontSize: 14,
        ),
        labelStyle: GoogleFonts.cairo(
          color: const Color.fromRGBO(33, 37, 41, 0.7),
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
        color: const Color.fromRGBO(233, 236, 239, 0.5),
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
        unselectedLabelColor: const Color.fromRGBO(33, 37, 41, 0.5),
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
        backgroundColor: const Color.fromRGBO(33, 37, 41, 0.8),
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

  // Add dark theme support
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      primaryColor: primaryGreen,
      colorScheme: const ColorScheme.dark(
        primary: primaryGreen,
        secondary: secondaryGreen,
        surface: Color(0xFF1E1E1E),
        surfaceVariant: Color(0xFF2D2D2D),
        error: Colors.redAccent,
        onPrimary: white,
        onSecondary: white,
        onSurface: white,
        onBackground: white,
        onError: black,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      // Rest of dark theme configuration
    );
  }

  // Helper method to get current theme
  static ThemeData getTheme(bool isDark) => isDark ? darkTheme : lightTheme;

  // Add semantic sizing
  static const double kIconSizeSmall = 16.0;
  static const double kIconSizeMedium = 24.0;
  static const double kIconSizeLarge = 32.0;

  static const double kFontSizeSmall = 12.0;
  static const double kFontSizeMedium = 14.0;
  static const double kFontSizeLarge = 16.0;
  static const double kFontSizeXLarge = 18.0;
  static const double kFontSizeXXLarge = 24.0;

  // Add z-index values
  static const double kElevationLow = 2.0;
  static const double kElevationMedium = 4.0;
  static const double kElevationHigh = 8.0;

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
        border: Border.all(
          color: const Color.fromRGBO(208, 191, 255, 0.3),
          width: 1,
        ),
      );
}
