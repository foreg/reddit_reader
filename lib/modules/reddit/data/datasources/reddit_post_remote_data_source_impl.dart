import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:reddit_reader/core/errors/exception.dart';
import 'package:reddit_reader/modules/reddit/data/datasources/reddit_post_remote_data_source.dart';
import 'package:reddit_reader/modules/reddit/data/models/reddit_post_list_model.dart';

const redditApiUrl = 'https://www.reddit.com/';

class RedditPostRemoteDataSourceImpl extends RedditPostRemoteDataSource {
  final http.Client httpClient;

  RedditPostRemoteDataSourceImpl(this.httpClient);

  @override
  Future<RedditPostListModel> getBestRedditPosts() =>
      _getRedditPosts(redditApiUrl + 'best.json');

  @override
  Future<RedditPostListModel> getRedditPosts(String subreddit) =>
      _getRedditPosts(redditApiUrl + 'r/$subreddit.json');

  Future<RedditPostListModel> _getRedditPosts(String url) async {
    final response = await httpClient.get(
      url,
      headers: {'content-type': 'application/json; charset=UTF-8'},
    );
    if (response.statusCode == 200) {
      return RedditPostListModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
