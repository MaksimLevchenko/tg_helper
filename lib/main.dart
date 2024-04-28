import 'package:flutter/material.dart';
import 'package:flutter_tg_helper/pages/login_page.dart';
import 'package:flutter_tg_helper/pages/main_page.dart';
import 'package:flutter_tg_helper/style/app_colors.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.mainDarkBlue,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.mainDarkBlue,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.mainLightBlue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
      ),
    ),
    routes: {
      '/': (context) => const LoginPage(),
      '/home': (context) => const MainPage(),
    },
    initialRoute: '/',
  ));
}
