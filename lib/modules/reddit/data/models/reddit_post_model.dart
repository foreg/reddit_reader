import 'package:meta/meta.dart';
import 'package:reddit_reader/modules/reddit/domain/entities/reddit_post.dart';

class RedditPostModel extends RedditPost {
  RedditPostModel({
    @required String subreddit,
    @required String authorFullName,
    @required String title,
    @required String name,
    @required String url,
  }) : super(
          subreddit: subreddit,
          authorFullName: authorFullName,
          title: title,
          name: name,
          url: url,
        );

  factory RedditPostModel.fromJson(Map<String, dynamic> jsonMap) {
    return RedditPostModel(
      subreddit: jsonMap['data']['subreddit'],
      authorFullName: jsonMap['data']['author_fullname'],
      title: jsonMap['data']['title'],
      name: jsonMap['data']['name'],
      url: jsonMap['data']['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'subreddit': subreddit,
        'authorFullName': authorFullName,
        'title': title,
        'name': name,
        'url': url,
      }
    };
  }
}
