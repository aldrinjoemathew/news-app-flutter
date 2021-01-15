// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsResponse _$NewsResponseFromJson(Map<String, dynamic> json) {
  return NewsResponse()
    ..status = json['status'] as String
    ..totalResult = json['totalResult'] as int
    ..articles = (json['articles'] as List)
        ?.map((e) =>
            e == null ? null : NewsArticle.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$NewsResponseToJson(NewsResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'totalResult': instance.totalResult,
      'articles': instance.articles,
    };

NewsArticle _$NewsArticleFromJson(Map<String, dynamic> json) {
  return NewsArticle()
    ..title = json['title'] as String
    ..description = json['description'] as String
    ..url = json['url'] as String
    ..urlToImage = json['urlToImage'] as String
    ..content = json['content'] as String
    ..publishedAt = json['publishedAt'] as String
    ..source = json['source'] == null
        ? null
        : Source.fromJson(json['source'] as Map<String, dynamic>);
}

Map<String, dynamic> _$NewsArticleToJson(NewsArticle instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'url': instance.url,
      'urlToImage': instance.urlToImage,
      'content': instance.content,
      'publishedAt': instance.publishedAt,
      'source': instance.source,
    };

Source _$SourceFromJson(Map<String, dynamic> json) {
  return Source()
    ..id = json['id'] as String
    ..name = json['name'] as String;
}

Map<String, dynamic> _$SourceToJson(Source instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
