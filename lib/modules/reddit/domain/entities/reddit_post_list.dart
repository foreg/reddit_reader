import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:reddit_reader/modules/reddit/domain/entities/reddit_post.dart';

class RedditPostList extends Equatable {
  final List<RedditPost> posts;

  RedditPostList({@required this.posts});

  @override
  List<Object> get props => [posts];
}
