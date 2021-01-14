import 'package:flutter/material.dart';

import 'app_utils.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News"),
      ),
      body: Text("News listing"),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        backgroundColor: getAppThemeColor(),
        items: [
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("assets/ic_news.png")), label: "News"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: "Favorites"),
        ],
      ),
    );
  }
}
