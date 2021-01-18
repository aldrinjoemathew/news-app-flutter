import 'package:flutter/material.dart';
import 'package:news_app/models/news_models.dart';

class NewsListPage extends StatefulWidget {


  @override
  _NewsListPageState createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  bool _loading = true;
  List<NewsArticle> _newsList = <NewsArticle>[];

  @override
  void initState() {
    _loadNews();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> stackChildren = [
      ListView.builder(
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
      )
    ];
    if (_loading) {
      stackChildren.add(Center(
        child: CircularProgressIndicator(),
      ));
    }
    return Container(
        child: Stack(
      children: stackChildren,
    ));
  }

  void _onTapNewsItem(NewsArticle newsItem) {
/*
    if (newsItem.description != null && newsItem.description.isNotEmpty) {
      showOkAlert(context, newsItem.title ?? "", newsItem.description ?? "");
    }
*/
  }

  @override
  void setState(fn) {
    if (this.mounted) super.setState(fn);
  }

  void _loadNews() async {
    final result = await getNewsList(context);
    setState(() {
      _newsList = result;
      _loading = false;
    });
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
        style: TextStyle(
          fontSize: 16,
        ),
        overflow: TextOverflow.ellipsis,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> childWidgets = [
      Text(
        newsItem.title,
        maxLines: 2,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        overflow: TextOverflow.ellipsis,
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
            icon: Icon(Icons.favorite_border),
            onPressed: () {},
          ),
        ),
        Padding(
          padding: EdgeInsets.all(4),
          child: IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
          ),
        )
      ],
    ));
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: childWidgets,
        ),
      ),
    );
  }
}
