import 'dart:convert';

import 'package:reddit_reader/core/errors/exception.dart';
import 'package:reddit_reader/modules/reddit/data/datasources/reddit_post_local_data_source.dart';
import 'package:reddit_reader/modules/reddit/data/models/reddit_post_list_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const cachedRedditPosts = 'cached_reddit_posts';

class RedditPostLocalDataSourceImpl extends RedditPostLocalDataSource {
  final SharedPreferences sharedPreferences;

  RedditPostLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheRedditPosts(RedditPostListModel posts) {
    return sharedPreferences.setString(cachedRedditPosts, json.encode(posts.toJson()));
  }

  @override
  Future<RedditPostListModel> getLastRedditPosts() {
    final cachedRedditPostsJson =
        sharedPreferences.getString('cached_reddit_posts');
    if (cachedRedditPostsJson == null) {
      throw CacheException();
    }
    return Future.value(
        RedditPostListModel.fromJson(json.decode(cachedRedditPostsJson)));
  }
}
