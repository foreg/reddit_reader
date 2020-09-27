import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reddit_reader/core/errors/exception.dart';
import 'package:reddit_reader/core/errors/failure.dart';
import 'package:reddit_reader/core/network/network_info.dart';
import 'package:reddit_reader/modules/reddit/data/datasources/reddit_post_local_data_source.dart';
import 'package:reddit_reader/modules/reddit/data/datasources/reddit_post_remote_data_source.dart';
import 'package:reddit_reader/modules/reddit/data/models/reddit_post_list_model.dart';
import 'package:reddit_reader/modules/reddit/data/models/reddit_post_model.dart';
import 'package:reddit_reader/modules/reddit/data/repositories/reddit_post_repository_impl.dart';
import 'package:reddit_reader/modules/reddit/domain/entities/reddit_post_list.dart';

class MockRedditPostLocalDataSource extends Mock
    implements RedditPostLocalDataSource {}

class MockRedditPostRemoteDataSource extends Mock
    implements RedditPostRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  RedditPostRepositoryImpl repository;
  MockRedditPostLocalDataSource mockRedditPostLocalDataSource;
  MockRedditPostRemoteDataSource mockRedditPostRemoteDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRedditPostLocalDataSource = MockRedditPostLocalDataSource();
    mockRedditPostRemoteDataSource = MockRedditPostRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = RedditPostRepositoryImpl(
      remoteDataSource: mockRedditPostRemoteDataSource,
      localDataSource: mockRedditPostLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('get list of reddit posts from subreddit', () {
    final tSubreddit = 'Flutter';
    final tRedditPostsModels = [
      RedditPostModel(
        authorFullName: 'authorFullName',
        name: 'name',
        subreddit: 'subreddit',
        title: 'best title',
        url: 'url',
      ),
      RedditPostModel(
        authorFullName: 'authorFullName',
        name: 'name',
        subreddit: 'subreddit',
        title: 'best1 title',
        url: 'url',
      ),
    ];
    final tRedditPostListModel = RedditPostListModel(posts: tRedditPostsModels);
    final RedditPostList tRedditPostList = tRedditPostListModel;

    test('should sheck for Internet availability', () {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      repository.getRedditPosts(tSubreddit);
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          when(mockRedditPostRemoteDataSource.getRedditPosts(tSubreddit))
              .thenAnswer((_) async => tRedditPostListModel);
          final result = await repository.getRedditPosts(tSubreddit);
          verify(mockRedditPostRemoteDataSource.getRedditPosts(tSubreddit));
          expect(result, equals(Right(tRedditPostListModel)));
        },
      );

      test('should cache data locally', () async {
        when(mockRedditPostRemoteDataSource.getRedditPosts(tSubreddit))
            .thenAnswer((_) async => tRedditPostListModel);
        await repository.getRedditPosts(tSubreddit);
        verify(mockRedditPostRemoteDataSource.getRedditPosts(tSubreddit));
        verify(mockRedditPostLocalDataSource.cacheRedditPosts(tRedditPostList));
      });

      test('should return ServerFailure when call is unsuccessfull', () async {
        when(mockRedditPostRemoteDataSource.getRedditPosts(tSubreddit))
            .thenThrow(ServerException());
        final result = await repository.getRedditPosts(tSubreddit);
        verify(mockRedditPostRemoteDataSource.getRedditPosts(tSubreddit));
        verifyZeroInteractions(mockRedditPostLocalDataSource);
        expect(result, Left(ServerFailure()));
      });
    });

    runTestsOffline(() {
      test(
        'should return last locally cached data when there is',
        () async {
          when(mockRedditPostLocalDataSource.getLastRedditPosts())
              .thenAnswer((_) async => tRedditPostList);
          final result = await repository.getRedditPosts(tSubreddit);
          verifyZeroInteractions(mockRedditPostRemoteDataSource);
          verify(mockRedditPostLocalDataSource.getLastRedditPosts());
          expect(result, equals(Right(tRedditPostList)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          when(mockRedditPostLocalDataSource.getLastRedditPosts())
              .thenThrow(CacheException());
          final result = await repository.getRedditPosts(tSubreddit);
          verifyZeroInteractions(mockRedditPostRemoteDataSource);
          verify(mockRedditPostLocalDataSource.getLastRedditPosts());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });

  group('get list of best reddit posts', () {
    final tRedditPostsModels = [
      RedditPostModel(
        authorFullName: 'authorFullName',
        name: 'name',
        subreddit: 'subreddit',
        title: 'best title',
        url: 'url',
      ),
      RedditPostModel(
        authorFullName: 'authorFullName',
        name: 'name',
        subreddit: 'subreddit',
        title: 'best1 title',
        url: 'url',
      ),
    ];
    final tRedditPostListModel = RedditPostListModel(posts: tRedditPostsModels);
    final RedditPostList tRedditPostList = tRedditPostListModel;

    test('should sheck for Internet availability', () {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      repository.getBestRedditPosts();
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          when(mockRedditPostRemoteDataSource.getBestRedditPosts())
              .thenAnswer((_) async => tRedditPostListModel);
          final result = await repository.getBestRedditPosts();
          verify(mockRedditPostRemoteDataSource.getBestRedditPosts());
          expect(result, equals(Right(tRedditPostListModel)));
        },
      );

      test('should cache data locally', () async {
        when(mockRedditPostRemoteDataSource.getBestRedditPosts())
            .thenAnswer((_) async => tRedditPostListModel);
        await repository.getBestRedditPosts();
        verify(mockRedditPostRemoteDataSource.getBestRedditPosts());
        verify(mockRedditPostLocalDataSource.cacheRedditPosts(tRedditPostList));
      });

      test('should return ServerFailure when call is unsuccessfull', () async {
        when(mockRedditPostRemoteDataSource.getBestRedditPosts())
            .thenThrow(ServerException());
        final result = await repository.getBestRedditPosts();
        verify(mockRedditPostRemoteDataSource.getBestRedditPosts());
        verifyZeroInteractions(mockRedditPostLocalDataSource);
        expect(result, Left(ServerFailure()));
      });
    });

    runTestsOffline(() {
      test(
        'should return last locally cached data when there is',
        () async {
          when(mockRedditPostLocalDataSource.getLastRedditPosts())
              .thenAnswer((_) async => tRedditPostList);
          final result = await repository.getBestRedditPosts();
          verifyZeroInteractions(mockRedditPostRemoteDataSource);
          verify(mockRedditPostLocalDataSource.getLastRedditPosts());
          expect(result, equals(Right(tRedditPostList)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          when(mockRedditPostLocalDataSource.getLastRedditPosts())
              .thenThrow(CacheException());
          final result = await repository.getBestRedditPosts();
          verifyZeroInteractions(mockRedditPostRemoteDataSource);
          verify(mockRedditPostLocalDataSource.getLastRedditPosts());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
