import 'package:flutter/material.dart';
import 'package:news_app/src/db/favorites_provider.dart';
import 'package:news_app/src/models/news_models.dart';
import 'package:news_app/src/utils/app_theme_utils.dart';
import 'package:news_app/src/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late List<NewsArticle>? _favorites =
      context.watch<FavoritesProvider>().favorites;

  @override
  void initState() {
    _loadFavorites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final stackChildren = <Widget>[];
    if (_favorites != null && _favorites!.isNotEmpty) {
      stackChildren.add(ListView.builder(
          itemCount: _favorites!.length,
          itemBuilder: (ctx, index) {
            final favorite = _favorites![index];
            return FavoriteListItem(favorite);
          }));
    } else {
      stackChildren.add(Center(
        child: Text(
          "No favorites",
          style: TextStyle(fontSize: 20, color: AppColors.darkKhaki),
        ),
      ));
    }
    return Stack(
      children: stackChildren,
    );
  }

  void _loadFavorites() {
    context.read<FavoritesProvider>().getFavorites();
  }
}

class FavoriteListItem extends StatelessWidget {
  final NewsArticle favoriteItem;

  FavoriteListItem(this.favoriteItem);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _onTapNewsItem(context);
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
        child: Padding(
          padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (favoriteItem.urlToImage != null &&
                  favoriteItem.urlToImage!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  child: Image.network(
                    favoriteItem.urlToImage!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      favoriteItem.title ?? '',
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (favoriteItem.description != null &&
                        favoriteItem.description!.isNotEmpty) ...[
                      SizedBox(height: 4),
                      Text(
                        favoriteItem.description ?? "",
                        maxLines: 3,
                        style: TextStyle(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: IconButton(
                          icon: Icon(Icons.share),
                          onPressed: () {
                            if (favoriteItem.content != null)
                              Share.share(favoriteItem.content!);
                          },
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onTapNewsItem(BuildContext context) {
    Navigator.of(context).pushNamed(
      AppRoutes.NewsDetail,
      arguments: favoriteItem,
    );
  }
}
