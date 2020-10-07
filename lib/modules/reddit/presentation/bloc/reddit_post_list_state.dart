part of 'reddit_post_list_bloc.dart';

abstract class RedditPostListState extends Equatable {
  const RedditPostListState();

  @override
  List<Object> get props => [];
}

class Empty extends RedditPostListState {}

class Loading extends RedditPostListState {}

class Loaded extends RedditPostListState {
  final RedditPostList redditPostList;

  Loaded({@required this.redditPostList});

  @override
  List<Object> get props => [redditPostList];
}

class Error extends RedditPostListState {
  final String message;

  Error({@required this.message});

  @override
  List<Object> get props => [message];
}
