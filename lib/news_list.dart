import 'package:flutter/material.dart';
import 'package:news_app/app_utils.dart';
import 'package:news_app/models/news_models.dart';

class NewsListPage extends StatefulWidget {
  final List<NewsArticle> _newsList;

  NewsListPage(this._newsList);

  @override
  _NewsListPageState createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, index) {
        final newsItem = widget._newsList[index];
        return Container(
            color: getAppThemeColor()[50],
            child: GestureDetector(
              child: NewsListItem(newsItem),
              onTap: () {
                _onTapNewsItem(newsItem);
              },
            ));
      },
      itemCount: widget._newsList.length,
    );
  }

  void _onTapNewsItem(NewsArticle newsItem) {
    showOkAlert(context, newsItem.title, newsItem.description);
  }
}

class NewsListItem extends StatelessWidget {
  final NewsArticle newsItem;

  NewsListItem(this.newsItem);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12))),
      margin: EdgeInsets.all(8),
      color: getAppThemeColor()[100],
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              newsItem.title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Image.network(
              newsItem.urlToImage,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              newsItem.description,
              maxLines: 3,
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
