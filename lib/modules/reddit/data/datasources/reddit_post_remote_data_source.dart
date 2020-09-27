import 'package:reddit_reader/modules/reddit/data/models/reddit_post_list_model.dart';

abstract class RedditPostRemoteDataSource {
  Future<RedditPostListModel> getBestRedditPosts();
  Future<RedditPostListModel> getRedditPosts(String subreddit);
}