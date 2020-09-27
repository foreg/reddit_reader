import 'package:meta/meta.dart';
import 'package:reddit_reader/modules/reddit/data/models/reddit_post_model.dart';
import 'package:reddit_reader/modules/reddit/domain/entities/reddit_post_list.dart';

class RedditPostListModel extends RedditPostList {
  RedditPostListModel({@required List<RedditPostModel> posts}) : super(posts: posts);

  factory RedditPostListModel.fromJson(Map<String, dynamic> jsonMap) {
    return RedditPostListModel(
        posts: (jsonMap['data']['children'] as List)
            .map((e) => RedditPostModel.fromJson(e))
            .toList());
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'children': posts.map((e) => (e as RedditPostModel).toJson()).toList(),
      }
    };
  }
}
