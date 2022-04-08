import 'package:flutter/material.dart';
import 'package:news_app/src/ui/favorites.dart';
import 'package:news_app/src/ui/user_settings.dart';
import 'package:news_app/src/utils/constants.dart';
import 'package:provider/provider.dart';

import '../models/filter_model.dart';
import 'news_feed.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pages = [
    Page(title: "News", page: NewsFeedPage()),
    Page(title: "Favorites", page: FavoritePage()),
    Page(title: "Settings", page: UserSettingsPage()),
  ];
  int _selectedIndex = 0;
  final _pageViewController = PageController();

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableProvider(
      create: (_) => NewsCategoryModel(),
      child: WillPopScope(
          child: Scaffold(
            appBar: AppBar(
              title: Text(_pages[_selectedIndex].title),
              actions: _selectedIndex == 2
                  ? [
                      IconButton(
                          icon: Icon(Icons.mode_edit),
                          onPressed: _openEditProfile)
                    ]
                  : null,
            ),
            body: PageView(
              controller: _pageViewController,
              children: [
                _pages[0].page,
                _pages[1].page,
                _pages[2].page,
              ],
              onPageChanged: _onTabSelected,
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              onTap: (index) {
                _onTabSelected(index);
              },
              items: [
                BottomNavigationBarItem(
                    icon: ImageIcon(
                      AssetImage("assets/ic_news_list.png"),
                      size: 25,
                    ),
                    activeIcon: Container(
                      width: 30,
                      height: 30,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: ImageIcon(
                          AssetImage("assets/ic_news_list_active.png"),
                        ),
                      ),
                    ),
                    label: "News"),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.favorite_border,
                      size: 25,
                    ),
                    activeIcon: Icon(
                      Icons.favorite,
                      size: 30,
                    ),
                    label: "Favorites"),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.settings_outlined,
                      size: 25,
                    ),
                    activeIcon: Icon(
                      Icons.settings,
                      size: 30,
                    ),
                    label: "Settings"),
              ],
            ),
          ),
          onWillPop: () async {
            if (_selectedIndex == 0) return true;
            _onTabSelected(0);
            return false;
          }),
    );
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageViewController.animateToPage(
      index,
      duration: Duration(milliseconds: 200),
      curve: Curves.bounceOut,
    );
  }

  void _openEditProfile() {
    Navigator.of(context).pushNamed(AppRoutes.EditProfile);
  }
}

class Page {
  String title;
  Widget page;

  Page({required this.title, required this.page});
}
