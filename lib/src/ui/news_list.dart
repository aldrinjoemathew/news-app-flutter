import 'package:flutter/material.dart';
import 'package:news_app/src/models/news_models.dart';
import 'package:news_app/src/repositories/news_repo.dart';
import 'package:news_app/src/utils/app_theme_utils.dart';
import 'package:news_app/src/utils/app_utils.dart';
import 'package:news_app/src/utils/constants.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share/share.dart';

class NewsListPage extends StatefulWidget {
  @override
  _NewsListPageState createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  bool _shouldLoadMore = true;
  bool _loading = true;
  bool _loadingMore = false;
  List<NewsArticle> _newsList = <NewsArticle>[];
  int _listCount = 0;
  String _error = "";
  bool _showFilter = false;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String _selectedCategory;

  @override
  void initState() {
    _selectedCategory = NewsData.getInstance().category;
    _loadNews(false);
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
          if (index > _listCount - 1) return null;
          if (_shouldLoadMore && index == _newsList.length - 4) {
            // Trigger load more when there are only 3 more items to the bottom.
            _loadMore();
          }
          _updateListCount();
          if (_loadingMore && index == _listCount - 1) {
            return Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          }
          final newsItem = _newsList[index];
          return GestureDetector(
            child: NewsListItem(
                newsItem,
                _onTapFavorite,
                NewsData.getInstance().isFavorite(newsItem),
                index == _newsList.length - 1),
            onTap: () {
              _onTapNewsItem(newsItem);
            },
          );
        },
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
    final filterFab = FloatingActionButton(
      onPressed: () {
        _onTapFilter(context);
      },
      child: Icon(Icons.filter_alt),
    );
    return Scaffold(
      backgroundColor: AppColors.beige,
      floatingActionButton: Padding(
        child: filterFab,
        padding: EdgeInsets.only(bottom: 16),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      // bottomSheet: _showFilter ? getCategoryBottomSheet() : null,
      body: Container(
          child: Stack(
        children: stackChildren,
      )),
    );
  }

  void _onTapFilter(BuildContext context) {
    showModalBottomSheet(
        context: context,
        barrierColor: AppColors.darkKhaki.withOpacity(0.3),
        isDismissible: true,
        isScrollControlled: true,
        builder: (ctx) {
          return getCategoryBottomSheet();
        });
    // setState(() {
    //   _showFilter = !_showFilter;
    // });
  }

  void _onTapFavorite(NewsArticle newsItem) {
    setState(() {
      NewsData.getInstance().updateFavorites(newsItem);
    });
  }

  bool isSelected(String c) {
    return this._selectedCategory == c;
  }

  Widget getCategoryBottomSheet() {
    Iterable<Widget> listViewChildren =
        NewsRepo.getNewsCategories().map((newsCategory) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: Container(
          margin: EdgeInsets.all(12),
          decoration: ShapeDecoration(
            color: isSelected(newsCategory.categoryName)
                ? AppColors.sienna.withOpacity(1)
                : AppColors.darkKhaki.withOpacity(1),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32))),
          ),
          padding: EdgeInsets.all(12),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                newsCategory.imageAsset ?? "assets/ic_news.png",
                height: 50,
                width: 50,
              ),
              SizedBox(height: 12),
              Text(newsCategory.categoryName,
                  style: TextStyle(
                      fontWeight: isSelected(newsCategory.categoryName)
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: AppColors.white,
                      fontSize: 18))
            ],
          ),
        ),
        onTap: () {
          _onTapCategory(newsCategory.categoryName);
        },
      );
    });
    /*listViewChildren =
        ListTile.divideTiles(tiles: listViewChildren, color: AppColors.white);*/
    final listView = ListView(
      children: listViewChildren.toList(),
    );
    return BottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32), topRight: Radius.circular(32))),
        backgroundColor: AppColors.darkOlive.withOpacity(0.95),
        onClosing: () {},
        builder: (ctx) {
          return Container(
            height: 500,
            padding: EdgeInsets.fromLTRB(0, 32, 0, 16),
            child: GridView.count(
              children: listViewChildren.toList(),
              crossAxisCount: 2,
              childAspectRatio: 1.1,
            ),
          );
        });
  }

  void _onTapCategory(String category) {
    if (category == _selectedCategory) {
      _selectedCategory = null;
    } else {
      _selectedCategory = category;
    }
    NewsRepo.updateCategory(_selectedCategory);
    setState(() {
      // _showFilter = !_showFilter;
      _loading = true;
    });
    _loadNews(true);
    Navigator.of(context).pop();
  }

  void _onTapNewsItem(NewsArticle newsItem) {
    Navigator.of(context).pushNamed(
      AppRoutes.NewsDetail,
      arguments: newsItem,
    );
  }

  @override
  void setState(fn) {
    if (this.mounted) super.setState(fn);
  }

  void _loadNews(bool refresh) async {
    final result =
        await NewsRepo.fetchNews(refresh: refresh, category: _selectedCategory);
    print("loadNews => ${result.status}");
    if (result.isSuccess()) {
      setState(() {
        _newsList = result.data;
        _updateListCount();
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
    final result =
        await NewsRepo.fetchNews(refresh: true, category: _selectedCategory);
    print("refreshNews => ${result.status}");
    if (result.isSuccess()) {
      setState(() {
        _newsList = result.data;
        _updateListCount();
        _shouldLoadMore = true;
      });
    }
    _refreshController.refreshCompleted();
  }

  void _loadMore() async {
    if (_loadingMore) return;
    print("Load more triggered");
    _loadingMore = true;
    final result =
        await NewsRepo.fetchNews(paginate: true, category: _selectedCategory);
    print("loadMore => ${result.status}");
    if (result.isSuccess()) {
      setState(() {
        _newsList = result.data;
        _updateListCount();
        _shouldLoadMore = true;
        _loadingMore = false;
      });
    } else if (result.isFailure()) {
      setState(() {
        _loadingMore = false;
      });
    } else if (result.isEmpty()) {
      setState(() {
        _loadingMore = false;
        _shouldLoadMore = false;
      });
    }
  }

  void _updateListCount() {
    _listCount = _loadingMore ? _newsList.length + 1 : _newsList.length;
  }
}

class NewsListItem extends StatefulWidget {
  final NewsArticle newsItem;

  final OnTapFavorite _onTapFavorite;
  final bool _isFavorite;
  final bool _isLastItem;

  NewsListItem(
      this.newsItem, this._onTapFavorite, this._isFavorite, this._isLastItem);

  @override
  _NewsListItemState createState() => _NewsListItemState();
}

class _NewsListItemState extends State<NewsListItem>
    with SingleTickerProviderStateMixin {
  AnimationController _animController;
  Animation _animation;
  final double _iconSize = 32;

  NewsArticle get _newsItem => widget.newsItem;

  @override
  void initState() {
    super.initState();
    _initFavoriteAnimation();
  }

  @override
  void dispose() {
    super.dispose();
    _animController?.dispose();
  }

  void _addImage(List<Widget> childWidgets) {
    if (_newsItem.urlToImage != null && _newsItem.urlToImage.isNotEmpty) {
      childWidgets.add(SizedBox(
        height: 8,
      ));
      childWidgets.add(ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        child: Image.network(
          _newsItem.urlToImage,
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
          errorBuilder: (ctx, error, stackTrace) {
            return Image.asset(
              "assets/ic_news_dummy.png",
              width: double.infinity,
              height: 100,
              fit: BoxFit.scaleDown,
            );
          },
        ),
      ));
    }
  }

  void _addDesc(List<Widget> childWidgets) {
    if (_newsItem.description != null && _newsItem.description.isNotEmpty) {
      childWidgets.add(SizedBox(
        height: 8,
      ));
      childWidgets.add(Text(
        _newsItem.description ?? "",
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
    final List<Widget> childWidgets = [];
    childWidgets.add(Text(
      _newsItem.title,
      maxLines: 2,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      overflow: TextOverflow.ellipsis,
    ));
    _addImage(childWidgets);
    childWidgets.add(Container(
      margin: EdgeInsets.only(top: 8),
      alignment: Alignment.centerLeft,
      child: Text(getFormattedDate(_newsItem.publishedAt) ?? ""),
    ));
    _addDesc(childWidgets);
    childWidgets.add(Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.all(4),
          child: IconButton(
            iconSize: _animation?.value ?? _iconSize,
            icon: widget._isFavorite
                ? Icon(Icons.favorite, color: AppColors.favoriteRed)
                : Icon(Icons.favorite_border),
            onPressed: () {
              widget._onTapFavorite(_newsItem);
              _startAnimation();
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(4),
          child: IconButton(
            iconSize: _iconSize,
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share(_newsItem.url);
            },
          ),
        )
      ],
    ));
    if (!widget._isLastItem) {
      childWidgets.add(Divider(color: AppColors.darkKhaki));
    } else {
      childWidgets.add(SizedBox(height: 60));
    }
    final content = Container(
      color: AppColors.beige,
      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: childWidgets,
      ),
    );
    final card = Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      margin: EdgeInsets.fromLTRB(8, 8, 8, widget._isLastItem ? 8 : 0),
      child: content,
    );
    return content;
  }

  void _startAnimation() async {
    await _animController?.forward();
    _animController?.reverse();
  }

  void _initFavoriteAnimation() {
    _animController = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    );
    _animation =
        Tween<double>(begin: _iconSize, end: 24).animate(_animController)
          ..addListener(() {
            setState(() {});
          });
  }
}

typedef void OnTapFavorite(NewsArticle newsArticle);