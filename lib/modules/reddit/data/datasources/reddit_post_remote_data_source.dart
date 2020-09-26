import 'package:reddit_reader/modules/reddit/domain/entities/reddit_post.dart';

abstract class RedditPostRemoteDataSource {
  Future<List<RedditPost>> getBestRedditPosts();
  Future<List<RedditPost>> getRedditPosts(String subreddit);
}