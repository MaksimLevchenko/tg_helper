import 'package:flutter/material.dart';
import 'package:flutter_tg_helper/style/app_colors.dart';
import 'package:flutter_tg_helper/style/text_style.dart';
import 'package:flutter_tg_helper/widgets/contacts_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int bottomAppBarValue = 0;

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
      const ChatsPage(),
      settingsPage(),
    ];
    return Scaffold(
        appBar: AppBar(
          backgroundColor: DarkThemeAppColors.backgroundColor,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: Container(
              color: Colors.black,
              height: 1,
            ),
          ),
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
              icon: Icon(Icons.chat),
              label: 'Chats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ));
  }
}
