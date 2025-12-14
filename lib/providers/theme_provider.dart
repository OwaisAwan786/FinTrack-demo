import 'package:flutter/material.dart';
import '../utils/constants.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  ThemeData get lightTheme => ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          error: AppColors.error,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        // ... (reuse the detailed input decoration and button themes from main.dart)
        inputDecorationTheme: _inputDecorationTheme(Colors.grey[50]!, Colors.grey[200]!),
        elevatedButtonTheme: _elevatedButtonTheme(),
      );

  ThemeData get darkTheme => ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: const Color(0xFF1E293B), // Dark Slate
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: const Color(0xFF0F172A),
          error: AppColors.error,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        inputDecorationTheme: _inputDecorationTheme(const Color(0xFF334155), const Color(0xFF475569)),
        elevatedButtonTheme: _elevatedButtonTheme(),
        textTheme:  Typography.whiteMountainView, // Default dark text logic
      );

  InputDecorationTheme _inputDecorationTheme(Color fillColor, Color borderColor) {
    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      labelStyle: const TextStyle(color: AppColors.textSecondary),
    );
  }

  ElevatedButtonThemeData _elevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        shadowColor: AppColors.primary.withOpacity(0.4),
      ),
    );
  }
}
