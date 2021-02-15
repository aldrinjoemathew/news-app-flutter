import 'dart:io';

import 'package:flutter/material.dart';
import 'package:news_app/src/models/news_models.dart';
import 'package:news_app/src/utils/app_theme_utils.dart';
import 'package:news_app/src/utils/app_utils.dart';
import 'package:news_app/src/utils/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsDetailPage extends StatelessWidget {
  final NewsArticle newsItem;

  NewsDetailPage(this.newsItem);

  bool _hasImage() {
    return newsItem.urlToImage != null && newsItem.urlToImage.isNotEmpty;
  }

  Widget _getNewsImageWidget() {
    if (_hasImage()) {
      return Opacity(
        opacity: 0.7,
        child: Image.network(
          newsItem.urlToImage,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }
    return null;
  }

  void _addContent(List<Widget> childWidgets) {
    if (newsItem.content != null && newsItem.content.isNotEmpty) {
      childWidgets.add(SizedBox(
        height: 8,
      ));
      childWidgets.add(Text(
        "${newsItem.content}\n${newsItem.content}\n${newsItem.content}" ?? "",
        style: TextStyle(
          fontSize: 22,
        ),
      ));
    }
  }

  Widget _getNewsTitleWidget() {
    return Text(
      "News Details",
      style: TextStyle(
        fontSize: 18,
        color: AppColors.white,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> childWidgets = [];
    childWidgets.add(Text(
      newsItem.title,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
    ));
    if (newsItem.author?.isNotEmpty == true) {
      childWidgets.add(Container(
        margin: EdgeInsets.only(top: 8),
        alignment: Alignment.centerLeft,
        child: Text(
          "By ${newsItem.author}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ));
    }
    childWidgets.add(Container(
      margin: EdgeInsets.only(top: 8),
      alignment: Alignment.centerLeft,
      child: Text(
        getFormattedDate(newsItem.publishedAt) ?? "",
        style: TextStyle(fontSize: 16),
      ),
    ));
    _addContent(childWidgets);
    // _addReadMore(context, childWidgets);
    final sliverParent = CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: AppColors.darkOlive,
          title: _getNewsTitleWidget(),
          expandedHeight: _hasImage() ? 250 : null,
          flexibleSpace: Opacity(
            opacity: 0.8,
            child: _getNewsImageWidget(),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.all(12),
          sliver: SliverList(
            delegate: SliverChildListDelegate(childWidgets),
          ),
        )
      ],
    );
    final appBar = AppBar(
      title: Text("News"),
      actions: [
        IconButton(
          icon: Icon(
            Icons.open_in_browser,
            color: AppColors.white,
          ),
          onPressed: () {
            _openWebView(context);
          },
        )
      ],
    );
    return Scaffold(
      body: sliverParent,
    );
  }

  void _openWebView(BuildContext context) {
    Navigator.of(context).pushNamed(
      AppRoutes.NewsWebView,
      arguments: newsItem.url,
    );
  }

  void _addReadMore(BuildContext context, List<Widget> childWidgets) {
    childWidgets.add(Wrap(
      alignment: WrapAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            _openWebView(context);
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
