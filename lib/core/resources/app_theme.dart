import 'package:flutter/material.dart';
import 'app_color.dart'; // Import your existing colors

class AppTheme {
  // Use existing AppColor
  static const Color primaryColor = AppColor.redPrimary;
  static const Color secondaryColor = AppColor.redSecondary;
  static const Color accentColor = AppColor.redExtraLight;
  static const Color textPrimary = AppColor.blackPrimary;
  static const Color textSecondary = AppColor.blackLight;
  static const Color background = AppColor.white;
  static const Color cardBackground = AppColor.white;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: AppColor.redPrimary,
        secondary: AppColor.redSecondary,
        surface: AppColor.white,
        background: AppColor.white,
      ),
      scaffoldBackgroundColor: AppColor.white,

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColor.white,
        foregroundColor: AppColor.blackPrimary,
        titleTextStyle: TextStyle(
          color: AppColor.blackPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: false,

        // Label style
        labelStyle: const TextStyle(
          fontSize: 14,
          color: AppColor.greyBold,
          fontWeight: FontWeight.w500,
        ),

        floatingLabelStyle: const TextStyle(
          color: AppColor.redPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),

        // Hint style
        hintStyle: TextStyle(
          fontSize: 14,
          color: AppColor.greyLight.withOpacity(0.8),
        ),

        // Content padding
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),

        // Icon colors
        prefixIconColor: AppColor.greyBold,
        suffixIconColor: AppColor.greyBold,

        // Borders - Soft rounded
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColor.grey.withOpacity(0.3),
            width: 1.5,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColor.grey.withOpacity(0.3),
            width: 1.5,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColor.redPrimary, width: 2.0),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColor.redLight.withOpacity(0.7),
            width: 1.5,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColor.redPrimary, width: 2.0),
        ),

        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColor.grey.withOpacity(0.2),
            width: 1.5,
          ),
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.redPrimary,
          foregroundColor: AppColor.white,
          elevation: 2,
          shadowColor: AppColor.redPrimary.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Card Theme
      // cardTheme: CardTheme(
      //   elevation: 2,
      //   shadowColor: AppColor.black.withOpacity(0.05),
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(20),
      //   ),
      //   color: AppColor.white,
      // ),

      // Dropdown Theme
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: const TextStyle(fontSize: 15, color: AppColor.blackPrimary),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColor.blackPrimary,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColor.blackPrimary,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColor.blackPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColor.blackPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColor.blackPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColor.blackPrimary,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: AppColor.blackPrimary),
        bodyMedium: TextStyle(fontSize: 14, color: AppColor.blackLight),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColor.blackLight,
        ),
      ),
    );
  }

  // Custom Input Decoration for special cases
  static InputDecoration customInput({
    required String labelText,
    IconData? prefixIcon,
    IconData? suffixIcon,
    VoidCallback? onSuffixTap,
    bool readOnly = false,
    String? hintText,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: Icon(prefixIcon, size: 22),
      suffixIcon: suffixIcon != null
          ? IconButton(icon: Icon(suffixIcon, size: 22), onPressed: onSuffixTap)
          : null,
      filled: readOnly,
      fillColor: readOnly ? AppColor.redExtraLight.withOpacity(0.1) : null,
    );
  }

  // Gradient for special effects (Red gradient)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [AppColor.redPrimary, AppColor.redSecondary, AppColor.redLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Orange gradient for accent
  static const LinearGradient accentGradient = LinearGradient(
    colors: [
      AppColor.orangePrimary,
      AppColor.orangeSecond,
      AppColor.orangeLight,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Yellow gradient for highlights
  static const LinearGradient highlightGradient = LinearGradient(
    colors: [
      AppColor.yellowPrimary,
      AppColor.yellowSecond,
      AppColor.yellowLight,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Box decoration for cards with gradient
  static BoxDecoration cardDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [AppColor.white, AppColor.redExtraLight.withOpacity(0.05)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: AppColor.redPrimary.withOpacity(0.08),
        blurRadius: 20,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // Glass effect decoration
  static BoxDecoration glassDecoration = BoxDecoration(
    color: AppColor.containerGlass,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: AppColor.containerBorder, width: 1.5),
    boxShadow: [
      BoxShadow(
        color: AppColor.black.withOpacity(0.1),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // Button with gradient
  static BoxDecoration gradientButtonDecoration = BoxDecoration(
    gradient: primaryGradient,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: AppColor.redPrimary.withOpacity(0.3),
        blurRadius: 12,
        offset: const Offset(0, 6),
      ),
    ],
  );
}
