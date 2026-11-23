import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Colours sampled from the Socialight mockups.
class AppColors {
  AppColors._();

  static const sky = Color(0xFF00C6FF);
  static const primary = Color(0xFF266BEB);
  static const primaryDisabled = Color(0xFF93B4F7);
  static const accent = Color(0xFFEBB741);

  /// Gold that stays readable as text on white (about 5:1, passes WCAG AA).
  static const accentText = Color(0xFF946300);

  /// Brighter gold for text on [primary] blue (passes 3:1 for bold large text).
  static const accentOnBlue = Color(0xFFFFD45C);

  /// Text on disabled (pale blue) buttons: readable but clearly inactive.
  static const disabledText = Color(0xFF2F4E8C);
  static const cyan = Color(0xFF00CFFF);
  static const field = Color(0xFFB1B1B1);
  static const fieldEmpty = Color(0xFFDDDDDD);
  static const fieldFilled = Color(0xFFF8F9FF);
  static const avatar = Color(0xFFD9D9D9);
  static const ink = Colors.black;
}

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.accent,
    ),
  );
  return base.copyWith(
    textTheme: GoogleFonts.montserratTextTheme(base.textTheme),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}

/// Large page title, e.g. "Quest", "Leader Board".
const titleStyle = TextStyle(fontSize: 36, fontWeight: FontWeight.w400, color: AppColors.ink);
const subtitleStyle = TextStyle(fontSize: 13, color: AppColors.ink);
