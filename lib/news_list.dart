import 'package:flutter/material.dart';
import 'package:news_app/app_utils.dart';
import 'package:news_app/models/news_models.dart';

class NewsListPage extends StatefulWidget {


  @override
  _NewsListPageState createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  List<NewsArticle> _newsList = <NewsArticle>[];

  @override
  void initState() {
    getNewsList(context).then((value) {
      setState(() {
        _newsList = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final li = <ListTile>[];
    return Container(
        color: getAppThemeColor()[50],
        child: ListView.builder(
          addAutomaticKeepAlives: false,
          itemBuilder: (ctx, index) {
            final newsItem = _newsList[index];
            return GestureDetector(
              child: NewsListItem(newsItem),
              onTap: () {
                _onTapNewsItem(newsItem);
              },
            );
          },
          itemCount: _newsList.length,
        ));
  }

  void _onTapNewsItem(NewsArticle newsItem) {
/*
    if (newsItem.description != null && newsItem.description.isNotEmpty) {
      showOkAlert(context, newsItem.title ?? "", newsItem.description ?? "");
    }
*/
  }
}

class NewsListItem extends StatelessWidget {
  final NewsArticle newsItem;

  NewsListItem(this.newsItem);

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
        maxLines: 3,
        style: TextStyle(fontSize: 16),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> childWidgets = [
      Text(
        newsItem.title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      )
    ];
    _addImage(childWidgets);
    _addDesc(childWidgets);
    childWidgets.add(Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.all(4),
          child: IconButton(
            color: getAppThemeColor(),
            icon: Icon(Icons.favorite_border),
            onPressed: () {},
          ),
        ),
        Padding(
          padding: EdgeInsets.all(4),
          child: IconButton(
            color: getAppThemeColor(),
            icon: Icon(Icons.share),
            onPressed: () {},
          ),
        )
      ],
    ));
    return Card(
      shadowColor: getAppThemeColor(),
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
      color: getAppThemeColor()[100],
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: childWidgets,
        ),
      ),
    );
  }
}
