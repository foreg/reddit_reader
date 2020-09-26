import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class RedditPost extends Equatable {
  final String subreddit;
  final String authorFullName;
  final String title;
  final String name;
  final String url;

  RedditPost({
    @required this.subreddit,
    @required this.authorFullName,
    @required this.title,
    @required this.name,
    @required this.url,
  });

  @override
  List<Object> get props => [
        subreddit,
        authorFullName,
        title,
        name,
        url,
      ];
}
