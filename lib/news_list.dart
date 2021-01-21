import 'package:flutter/material.dart';
import 'package:news_app/models/news_models.dart';
import 'package:news_app/news_detail.dart';
import 'package:news_app/utils/app_theme_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NewsListPage extends StatefulWidget {
  @override
  _NewsListPageState createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  bool _loading = true;
  List<NewsArticle> _newsList = <NewsArticle>[];
  String _error = "";
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    _loadNews();
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> stackChildren = [];
    if (_newsList != null && _newsList.isNotEmpty) {
      final listView = ListView.builder(
        addAutomaticKeepAlives: false,
        itemBuilder: (ctx, index) {
          final newsItem = _newsList[index];
          return GestureDetector(
            child: NewsListItem(newsItem, _onTapFavorite,
                NewsData.getInstance().isFavorite(newsItem)),
            onTap: () {
              _onTapNewsItem(newsItem);
            },
          );
        },
        itemCount: _newsList.length,
      );

      stackChildren.add(SmartRefresher(
        controller: _refreshController,
        child: listView,
        onRefresh: _refreshNews,
        enablePullDown: true,
      ));
    } else {
      stackChildren.add(Center(
        child: Text(
          _error ?? "No data available",
          style: TextStyle(fontSize: 20, color: AppColors.darkKhaki),
        ),
      ));
    }
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

  void _onTapFavorite(NewsArticle newsItem) {
    setState(() {
      NewsData.getInstance().updateFavorites(newsItem);
    });
  }

  void _onTapNewsItem(NewsArticle newsItem) {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
      return NewsDetailPage(newsItem);
    }));
  }

  @override
  void setState(fn) {
    if (this.mounted) super.setState(fn);
  }

  void _loadNews() async {
    final result = await fetchNews(false);
    print("loadNews => ${result.status}");
    if (result.isSuccess()) {
      setState(() {
        _newsList = result.data;
        _loading = false;
      });
    } else if (result.isFailure()) {
      setState(() {
        _error = result.error;
        _loading = false;
      });
    }
  }

  void _refreshNews() async {
    final result = await fetchNews(true);
    print("refreshNews => ${result.status}");
    if (result.isSuccess()) {
      setState(() {
        _newsList = result.data;
      });
      _refreshController.refreshCompleted();
    }
  }
}

class NewsListItem extends StatelessWidget {
  final NewsArticle newsItem;

  final OnTapFavorite _onTapFavorite;
  final bool _isFavorite;

  NewsListItem(this.newsItem, this._onTapFavorite, this._isFavorite);

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
          fontWeight: FontWeight.w700,
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
            icon: _isFavorite
                ? Icon(Icons.favorite, color: AppColors.favoriteRed)
                : Icon(Icons.favorite_border),
            onPressed: () {
              _onTapFavorite(newsItem);
            },
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

typedef void OnTapFavorite(NewsArticle newsArticle);