import 'package:flutter/material.dart';
import 'package:news_app/models/news_models.dart';

import 'app_utils.dart';
import 'news_list.dart';

class HomePage extends StatefulWidget {
  final _pages = [
    NewsListPage(getNewsList()),
    Text("Favorites"),
    Text("Settings")
  ];

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News"),
      ),
      body: widget._pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 16,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        backgroundColor: getAppThemeColor(),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _onTabSelected,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "News"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: "Favorites"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
