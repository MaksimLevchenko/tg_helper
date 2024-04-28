import 'package:flutter/material.dart';
import 'package:flutter_tg_helper/style/text_style.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int bottomAppBarValue = 0;

  Widget homePage() {
    return const Center(
      child: Text('Welcome to the main page!'),
    );
  }

  Widget settingsPage() {
    return const Center(
      child: Text('Settings page'),
    );
  }

  void onSelectTab(int index) {
    setState(() {
      bottomAppBarValue = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetList = [
      homePage(),
      settingsPage(),
    ];
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Main Page',
            style: AppTextStyle.textStyle.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: widgetList[bottomAppBarValue],
        bottomNavigationBar: BottomNavigationBar(
          onTap: onSelectTab,
          currentIndex: bottomAppBarValue,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ));
  }
}
