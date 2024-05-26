import 'package:flutter/material.dart';
import 'package:flutter_tg_helper/pages/login_page.dart';
import 'package:flutter_tg_helper/pages/main_page.dart';
import 'package:flutter_tg_helper/style/app_colors.dart';
import 'package:tdlib/tdlib.dart';

void main() async {
  await TdPlugin.initialize();
  runApp(MaterialApp(
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: DarkThemeAppColors.primaryColor,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: DarkThemeAppColors.primaryColor,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: DarkThemeAppColors.backgroundColor,
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
