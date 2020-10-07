import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reddit_reader/core/errors/failure.dart';
import 'package:reddit_reader/core/usecases/usecase.dart';
import 'package:reddit_reader/core/utils/input_converter.dart';
import 'package:reddit_reader/modules/reddit/domain/entities/reddit_post.dart';
import 'package:reddit_reader/modules/reddit/domain/entities/reddit_post_list.dart';
import 'package:reddit_reader/modules/reddit/domain/usecases/get_best_reddit_posts.dart';
import 'package:reddit_reader/modules/reddit/domain/usecases/get_sub_reddit_posts.dart';
import 'package:reddit_reader/modules/reddit/presentation/bloc/reddit_post_list_bloc.dart';

class MockGetBestRedditPosts extends Mock implements GetBestRedditPosts {}

class MockGetSubRedditPosts extends Mock implements GetSubRedditPosts {}

class MockInputConvertor extends Mock implements InputConverter {}

void main() {
  MockGetBestRedditPosts getBestRedditPosts;
  MockGetSubRedditPosts getSubRedditPosts;
  MockInputConvertor inputConverter;
  RedditPostListBloc bloc;

  setUp(() {
    getBestRedditPosts = MockGetBestRedditPosts();
    getSubRedditPosts = MockGetSubRedditPosts();
    inputConverter = MockInputConvertor();
    bloc = RedditPostListBloc(
      getBestRedditPosts: getBestRedditPosts,
      getSubRedditPosts: getSubRedditPosts,
      inputConvertor: inputConverter,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state is Empty', () {
    expect(bloc.state, Empty());
  });

  group('GetSubRedditPosts', () {
    final tSubreddit = 'Flutter';
    final tRedditPosts = [
      RedditPost(
        authorFullName: 'authorFullName',
        name: 'name',
        subreddit: 'Flutter',
        title: 'Flutter title',
        url: 'url',
      ),
      RedditPost(
        authorFullName: 'authorFullName',
        name: 'name',
        subreddit: 'Flutter',
        title: 'Flutter1 title',
        url: 'url',
      ),
    ];
    final tRedditPostList = RedditPostList(posts: tRedditPosts);

    void setUpMockInputConverterSuccess() =>
        when(inputConverter.checkStringLength(any))
            .thenReturn(Right(tSubreddit));

    test('should call InputConverter to validate string', () async {
      setUpMockInputConverterSuccess();
      bloc.add(GetSubRedditPostsEvent(subreddit: tSubreddit));
      await untilCalled(inputConverter.checkStringLength(any));
      verify(inputConverter.checkStringLength(tSubreddit));
    });

    blocTest(
      'should emit [Error] when the input is invalid',
      build: () => bloc,
      act: (bloc) {
        when(inputConverter.checkStringLength(any))
            .thenReturn(Left(InvalidInputFailure()));
        bloc.add(GetSubRedditPostsEvent(subreddit: tSubreddit));
      },
      expect: [Error(message: invalidInputFailureMessage)],
    );

    test('should get data from GetSubRedditPosts use case', () async {
      setUpMockInputConverterSuccess();
      when(getSubRedditPosts(any))
          .thenAnswer((_) async => Right(tRedditPostList));
      bloc.add(GetSubRedditPostsEvent(subreddit: tSubreddit));
      await untilCalled(getSubRedditPosts(any));
      verify(getSubRedditPosts(Params(subreddit: tSubreddit)));
    });

    blocTest(
      'should emit [Loading, Loaded] when the data is gotten successfully',
      build: () => bloc,
      act: (bloc) {
        setUpMockInputConverterSuccess();
        when(getSubRedditPosts(any))
          .thenAnswer((_) async => Right(tRedditPostList));
        bloc.add(GetSubRedditPostsEvent(subreddit: tSubreddit));
      },
      expect: [Loading(), Loaded(redditPostList: tRedditPostList)],
    );

    blocTest(
      'should emit [Loading, Error] when the data is gotten unsuccessfully',
      build: () => bloc,
      act: (bloc) {
        setUpMockInputConverterSuccess();
        when(getSubRedditPosts(any))
          .thenAnswer((_) async => Left(ServerFailure()));
        bloc.add(GetSubRedditPostsEvent(subreddit: tSubreddit));
      },
      expect: [Loading(), Error(message: serverFailureMessage)],
    );

    blocTest(
      'should emit [Loading, Error] when the data is gotten unsuccessfully from cache',
      build: () => bloc,
      act: (bloc) {
        setUpMockInputConverterSuccess();
        when(getSubRedditPosts(any))
          .thenAnswer((_) async => Left(CacheFailure()));
        bloc.add(GetSubRedditPostsEvent(subreddit: tSubreddit));
      },
      expect: [Loading(), Error(message: cacheFailureMessage)],
    );
  });

  group('GetBestRedditPosts', () {
    final tRedditPosts = [
      RedditPost(
        authorFullName: 'authorFullName',
        name: 'name',
        subreddit: 'subreddit',
        title: 'title',
        url: 'url',
      ),
      RedditPost(
        authorFullName: 'authorFullName',
        name: 'name',
        subreddit: 'subreddit',
        title: 'title',
        url: 'url',
      ),
    ];
    final tRedditPostList = RedditPostList(posts: tRedditPosts);

    test('should get data from GetBestRedditPosts use case', () async {
      when(getBestRedditPosts(any))
          .thenAnswer((_) async => Right(tRedditPostList));
      bloc.add(GetBestRedditPostsEvent());
      await untilCalled(getBestRedditPosts(any));
      verify(getBestRedditPosts(NoParams()));
    });

    blocTest(
      'should emit [Loading, Loaded] when the data is gotten successfully',
      build: () => bloc,
      act: (bloc) {
        when(getBestRedditPosts(any))
          .thenAnswer((_) async => Right(tRedditPostList));
        bloc.add(GetBestRedditPostsEvent());
      },
      expect: [Loading(), Loaded(redditPostList: tRedditPostList)],
    );

    blocTest(
      'should emit [Loading, Error] when the data is gotten unsuccessfully',
      build: () => bloc,
      act: (bloc) {
        when(getBestRedditPosts(any))
          .thenAnswer((_) async => Left(ServerFailure()));
        bloc.add(GetBestRedditPostsEvent());
      },
      expect: [Loading(), Error(message: serverFailureMessage)],
    );

    blocTest(
      'should emit [Loading, Error] when the data is gotten unsuccessfully from cache',
      build: () => bloc,
      act: (bloc) {
        when(getBestRedditPosts(any))
          .thenAnswer((_) async => Left(CacheFailure()));
        bloc.add(GetBestRedditPostsEvent());
      },
      expect: [Loading(), Error(message: cacheFailureMessage)],
    );
  });
}
