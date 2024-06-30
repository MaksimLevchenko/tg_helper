import 'package:flutter/material.dart';
import 'package:flutter_tg_helper/pages/login_screen/code_screen/code_page.dart';
import 'package:flutter_tg_helper/pages/login_screen/login_form/login_page.dart';
import 'package:flutter_tg_helper/pages/main_screen/chat/chat_page.dart';
import 'package:flutter_tg_helper/pages/main_screen/main_page.dart';
import 'package:flutter_tg_helper/pages/splash_screen/splash.dart';
import 'package:flutter_tg_helper/style/app_colors.dart';

void main() async {
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
      '/': (context) => const SplashScreen(),
      '/login': (context) => const LoginPage(),
      '/login/code': (context) => LoginCodePage(),
      '/home': (context) => const MainPage(),
      'home/chat': (context) {
        if (ModalRoute.of(context)!.settings.arguments is int) {
          final int chatId = ModalRoute.of(context)!.settings.arguments as int;
          return ChatPage(chatId: chatId);
        } else {
          return const MainPage();
        }
      },
    },
    initialRoute: '/',
  ));
}
