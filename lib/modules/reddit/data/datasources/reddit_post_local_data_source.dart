import 'package:reddit_reader/modules/reddit/domain/entities/reddit_post.dart';

abstract class RedditPostLocalDataSource {
  Future<List<RedditPost>> getLastRedditPosts();
  Future<void> cacheRedditPosts(List<RedditPost> posts);
}