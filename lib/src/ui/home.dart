import 'package:flutter/material.dart';
import 'package:news_app/src/ui/favorites.dart';
import 'package:news_app/src/ui/user_settings.dart';
import 'package:news_app/src/utils/constants.dart';

import 'news_list.dart';

class HomePage extends StatefulWidget {
  final _pages = [
    NewsListPage(),
    FavoritePage(),
    UserSettingsPage(),
  ];
  final _titles = [
    "News",
    "Favorites",
    "Settings",
  ];

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> appBarActions = [];
    if (_selectedIndex == 2) {
      appBarActions = [
        IconButton(icon: Icon(Icons.mode_edit), onPressed: _openEditProfile)
      ];
    }
    final scaffold = Scaffold(
      appBar: AppBar(
        title: Text(widget._titles[_selectedIndex]),
        actions: appBarActions,
      ),
      body: widget._pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _onTabSelected,
        items: [
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("assets/ic_news_list.png")),
              activeIcon:
              ImageIcon(AssetImage("assets/ic_news_list_active.png")),
              label: "News"),
          BottomNavigationBarItem(
              activeIcon: Icon(Icons.favorite),
              icon: Icon(Icons.favorite_border),
              label: "Favorites"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: "Settings"),
        ],
      ),
    );

    final willPopScope = WillPopScope(
        child: scaffold,
        onWillPop: () async {
          if (_selectedIndex == 0) return true;
          _onTabSelected(0);
          return false;
        });

    return willPopScope;
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openEditProfile() {
    Navigator.of(context).pushNamed(AppRoutes.EditProfile);
  }
}
