import 'package:flutter/material.dart';
import 'screens/portfolio_home.dart';
import 'theme/app_colors.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfolio Saya',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.primaryDark,
          surface: AppColors.surface,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          displayMedium: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          bodyLarge: TextStyle(fontSize: 18, color: AppColors.textSecondary),
          bodyMedium: TextStyle(fontSize: 16, color: AppColors.textMuted),
        ),
      ),
      home: const PortfolioHome(),
    );
  }
}
