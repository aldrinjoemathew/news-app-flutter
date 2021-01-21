import 'package:flutter/material.dart';

import 'models/news_models.dart';

class NewsDetailPage extends StatelessWidget {
  final NewsArticle newsItem;

  NewsDetailPage(this.newsItem);

  void _addImage(List<Widget> childWidgets) {
    if (newsItem.urlToImage != null && newsItem.urlToImage.isNotEmpty) {
      childWidgets.add(SizedBox(
        height: 8,
      ));
      childWidgets.add(ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        child: Image.network(
          newsItem.urlToImage,
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
        ),
      ));
    }
  }

  void _addDesc(List<Widget> childWidgets) {
    if (newsItem.description != null && newsItem.description.isNotEmpty) {
      childWidgets.add(SizedBox(
        height: 8,
      ));
      childWidgets.add(Text(
        newsItem.description ?? "",
        style: TextStyle(
          fontSize: 16,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> childWidgets = [
      Text(
        newsItem.title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      )
    ];
    _addImage(childWidgets);
    _addDesc(childWidgets);
    return Scaffold(
      appBar: AppBar(
        title: Text("News"),
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: ListView(
          children: childWidgets,
        ),
      ),
    );
  }
}
