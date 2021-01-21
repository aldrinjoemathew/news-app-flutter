import 'dart:io';

import 'package:flutter/material.dart';
import 'package:news_app/utils/app_theme_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

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

  void _addContent(List<Widget> childWidgets) {
    if (newsItem.content != null && newsItem.content.isNotEmpty) {
      childWidgets.add(SizedBox(
        height: 8,
      ));
      childWidgets.add(Text(
        newsItem.content ?? "",
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
    _addContent(childWidgets);
    childWidgets.add(Wrap(
      alignment: WrapAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            _readMore(context);
          },
          child: Text(
            "Read more",
            style: TextStyle(
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
              color: AppColors.darkKhaki,
              fontSize: 16,
            ),
          ),
        )
      ],
    ));
    return Scaffold(
      appBar: AppBar(
        title: Text("News"),
      ),
      body: Container(
        color: AppColors.surfaceBg,
        padding: EdgeInsets.all(16),
        child: ListView(
          children: childWidgets,
        ),
      ),
    );
  }

  void _readMore(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
      return NewsWebPage(newsItem.url);
    }));
  }
}

class NewsWebPage extends StatefulWidget {
  final String url;

  NewsWebPage(this.url);

  @override
  _NewsWebPageState createState() => _NewsWebPageState();
}

class _NewsWebPageState extends State<NewsWebPage> {
  @override
  Widget build(BuildContext context) {
    print("Loading webview with ${widget.url}");
    return Scaffold(
      appBar: AppBar(
        title: Text("News"),
      ),
      body: WebView(initialUrl: widget.url),
    );
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }
}
