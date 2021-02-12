class NewsCategory {
  String categoryName;
  String imageAsset;

  NewsCategory(this.categoryName, {this.imageAsset});

  NewsCategory.fromJson(dynamic json) {
    categoryName = json["categoryName"];
    imageAsset = json["imageAsset"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["categoryName"] = categoryName;
    map["imageAsset"] = imageAsset;
    return map;
  }
}
