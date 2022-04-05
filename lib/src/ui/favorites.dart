import 'package:flutter/material.dart';
import 'package:news_app/src/models/news_models.dart';
import 'package:news_app/src/repositories/news_repo.dart';
import 'package:news_app/src/utils/app_theme_utils.dart';
import 'package:news_app/src/utils/constants.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late List<NewsArticle> _favorites;

  @override
  void initState() {
    _loadFavorites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final stackChildren = <Widget>[];
    if (_favorites != null && _favorites.isNotEmpty) {
      stackChildren.add(ListView.builder(
          itemCount: _favorites.length,
          itemBuilder: (ctx, index) {
            final favorite = _favorites[index];
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

  void _loadFavorites() async {
    setState(() {
      _favorites = NewsData.getInstance().favorites;
    });
  }
}

class FavoriteListItem extends StatelessWidget {
  final NewsArticle favoriteItem;

  FavoriteListItem(this.favoriteItem);

  void _addImage(List<Widget> childWidgets) {
    if (favoriteItem.urlToImage != null && favoriteItem.urlToImage!.isNotEmpty) {
      childWidgets.add(ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        child: Image.network(
          favoriteItem.urlToImage!,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
      ));
    }
  }

  void _addDesc(List<Widget> childWidgets) {
    if (favoriteItem.description != null &&
        favoriteItem.description!.isNotEmpty) {
      childWidgets.add(SizedBox(
        height: 4,
      ));
      childWidgets.add(Text(
        favoriteItem.description ?? "",
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
    final List<Widget> rowChildren = [];
    _addImage(rowChildren);
    final List<Widget> columnChildren = [];
    columnChildren.add(Text(
      favoriteItem.title ?? '',
      maxLines: 2,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      overflow: TextOverflow.ellipsis,
    ));
    _addDesc(columnChildren);
    columnChildren.add(Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.all(4),
        child: IconButton(
          icon: Icon(Icons.share),
          onPressed: () {},
        ),
      ),
    ));
    rowChildren.add(SizedBox(
      width: 8,
    ));
    rowChildren.add(Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: columnChildren,
      ),
    ));
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
            children: rowChildren,
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
