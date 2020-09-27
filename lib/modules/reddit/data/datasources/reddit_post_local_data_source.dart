import 'package:reddit_reader/modules/reddit/data/models/reddit_post_list_model.dart';

abstract class RedditPostLocalDataSource {
  Future<RedditPostListModel> getLastRedditPosts();
  Future<void> cacheRedditPosts(RedditPostListModel posts);
}