import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:news_app/src/models/news_models.dart';
import 'package:news_app/src/repositories/news_repo.dart';
import 'package:news_app/src/utils/app_theme_utils.dart';
import 'package:news_app/src/utils/app_utils.dart';
import 'package:news_app/src/utils/constants.dart';
import 'package:news_app/src/utils/extensions.dart';
import 'package:provider/provider.dart';

import '../db/favorites_provider.dart';

class NewsFeedPage extends StatefulWidget {
  @override
  _NewsFeedPageState createState() => _NewsFeedPageState();
}

class _NewsFeedPageState extends State<NewsFeedPage> {
  late FavoritesProvider _favorites = context.watch<FavoritesProvider>();
  String? _selectedCategory;
  final PagingController<int, NewsArticle> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    _selectedCategory = NewsData.getInstance().category;
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    _loadFavorites();
    super.initState();
  }

  void _loadFavorites() {
    context.read<FavoritesProvider>().getFavorites();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        child: FloatingActionButton(
          onPressed: () {
            showCategoryFilter(context);
          },
          child: Icon(Icons.filter_alt),
        ),
        padding: EdgeInsets.only(bottom: 16),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _pagingController.refresh(),
        ),
        child: Container(
          color: AppColors.beige,
          child: CustomScrollView(slivers: <Widget>[
            SliverToBoxAdapter(
              child: SizedBox(height: 10),
            ),
            //For Some reason PagedSliverList at the top of the list is not working
            PagedSliverList<int, NewsArticle>.separated(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<NewsArticle>(
                itemBuilder: (context, newsItem, index) => GestureDetector(
                  child: NewsListItem(
                    newsItem,
                    _onTapFavorite,
                    _isFavorite(newsItem),
                  ),
                  onTap: () {
                    _onTapNewsItem(newsItem);
                  },
                ),
              ),
              separatorBuilder: (context, index) => Divider(
                color: AppColors.darkKhaki,
                indent: 10,
                endIndent: 10,
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 60),
            ),
          ]),
        ),
      ),
    );
  }

  void _onTapFavorite(NewsArticle newsItem) {
    _favorites.toggleFavorite(newsItem);
  }

  bool isSelected(String c) {
    return this._selectedCategory == c;
  }

  void showCategoryFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.25,
          maxChildSize: 0.3,
          builder: (context, controller) {
            return ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              child: Container(
                color: AppColors.darkKhaki,
                child: ListView.builder(
                    physics: ClampingScrollPhysics(),
                    controller: controller,
                    itemCount: NewsRepo.categories.length,
                    itemBuilder: (_, i) {
                      var item = NewsRepo.categories[i];
                      return GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        child: Container(
                          color: isSelected(item)
                              ? AppColors.darkKhaki.withOpacity(0.5)
                              : null,
                          padding: EdgeInsets.all(12),
                          alignment: Alignment.center,
                          child: Text(
                            item.toCapitalized(),
                            style: TextStyle(
                                fontWeight: isSelected(item)
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: AppColors.white,
                                fontSize: isSelected(item) ? 20 : 16),
                          ),
                        ),
                        onTap: () {
                          _onTapCategory(item);
                        },
                      );
                    }),
              ),
            );
          },
        );
      },
    );
  }

  void _onTapCategory(String category) {
    if (category == _selectedCategory) {
      _selectedCategory = null;
    } else {
      _selectedCategory = category;
    }
    NewsRepo.updateCategory(_selectedCategory);
    _pagingController.refresh();
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

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems =
          await NewsRepo.fetchNewsPage(pageKey, category: _selectedCategory);
      final isLastPage = newItems.length < NewsRepo.PAGE_SIZE;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  bool _isFavorite(NewsArticle newsItem) => _favorites.isFavorite(newsItem);
}

class NewsListItem extends StatelessWidget {
  final NewsArticle newsItem;
  final OnTapFavorite _onTapFavorite;
  final bool _isFavorite;

  NewsListItem(
    this.newsItem,
    this._onTapFavorite,
    this._isFavorite,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.beige,
      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          newsItem.title ?? '',
          maxLines: 2,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        if (newsItem.urlToImage != null && newsItem.urlToImage!.isNotEmpty) ...[
          SizedBox(
            height: 8,
          ),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            child: Image.network(
              newsItem.urlToImage!,
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
          )
        ],
        Container(
          margin: EdgeInsets.only(top: 8),
          alignment: Alignment.centerLeft,
          child: Text(getFormattedDate(newsItem.publishedAt) ?? ""),
        ),
        if (newsItem.description != null &&
            newsItem.description!.isNotEmpty) ...[
          SizedBox(
            height: 8,
          ),
          Text(
            newsItem.description ?? "",
            maxLines: 3,
            style: TextStyle(
              fontSize: 16,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
        Row(
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
        )
      ]),
    );
  }
}

typedef void OnTapFavorite(NewsArticle newsArticle);
