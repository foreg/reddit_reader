import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:reddit_reader/core/errors/failure.dart';
import 'package:reddit_reader/core/usecases/usecase.dart';
import 'package:reddit_reader/core/utils/input_converter.dart';
import 'package:reddit_reader/modules/reddit/domain/entities/reddit_post.dart';
import 'package:reddit_reader/modules/reddit/domain/entities/reddit_post_list.dart';
import 'package:reddit_reader/modules/reddit/domain/usecases/get_best_reddit_posts.dart';
import 'package:reddit_reader/modules/reddit/domain/usecases/get_sub_reddit_posts.dart';

part 'reddit_post_list_event.dart';
part 'reddit_post_list_state.dart';

const String serverFailureMessage = 'Server Failure';
const String cacheFailureMessage = 'Cache Failure';
const String invalidInputFailureMessage =
    'Invalid Input - The string must be less than 20 chars';

class RedditPostListBloc
    extends Bloc<RedditPostListEvent, RedditPostListState> {
  final GetBestRedditPosts getBestRedditPosts;
  final GetSubRedditPosts getSubRedditPosts;
  final InputConverter inputConvertor;

  RedditPostListBloc({
    @required GetBestRedditPosts getBestRedditPosts,
    @required GetSubRedditPosts getSubRedditPosts,
    @required InputConverter inputConvertor,
  })  : assert(getBestRedditPosts != null),
        assert(getSubRedditPosts != null),
        assert(inputConvertor != null),
        this.getBestRedditPosts = getBestRedditPosts,
        this.getSubRedditPosts = getSubRedditPosts,
        this.inputConvertor = inputConvertor,
        super(Empty());

  @override
  Stream<RedditPostListState> mapEventToState(
    RedditPostListEvent event,
  ) async* {
    if (event is GetSubRedditPostsEvent) {
      yield* _mapGetSubRedditPostsEventToState(event);
    } else if (event is GetBestRedditPostsEvent) {
      yield* _mapGetBestRedditPostsEventToState(event);
    }
  }

  Stream<RedditPostListState> _mapGetSubRedditPostsEventToState(
      GetSubRedditPostsEvent event) async* {
    final inputEither = inputConvertor.checkStringLength(event.subreddit);
    yield* inputEither.fold(
      (failure) async* {
        yield Error(message: invalidInputFailureMessage);
      },
      (string) async* {
        yield Loading();
        final resultEither =
            await getSubRedditPosts(Params(subreddit: event.subreddit));
        yield resultEither.fold(
          (failure) => Error(message: _getMessageForFailure(failure)),
          (redditPostList) => Loaded(redditPostList: redditPostList),
        );
      },
    );
  }

  Stream<RedditPostListState> _mapGetBestRedditPostsEventToState(
      GetBestRedditPostsEvent event) async* {
    yield Loading();
    final resultEither =
        await getBestRedditPosts(NoParams());
    yield resultEither.fold(
      (failure) => Error(message: _getMessageForFailure(failure)),
      (redditPostList) => Loaded(redditPostList: redditPostList),
    );
  }

  String _getMessageForFailure(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      case CacheFailure:
        return cacheFailureMessage;
      default:
        return 'Unknown error';
    }
  }
}
