part of 'reddit_post_list_bloc.dart';

abstract class RedditPostListEvent extends Equatable {
  const RedditPostListEvent();

  @override
  List<Object> get props => [];
}

class GetBestRedditPostsEvent extends RedditPostListEvent {}

class GetSubRedditPostsEvent extends RedditPostListEvent {
  final String subreddit;

  GetSubRedditPostsEvent({this.subreddit});
  @override
  List<Object> get props => [subreddit];
}
