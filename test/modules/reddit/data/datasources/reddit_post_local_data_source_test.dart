import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reddit_reader/core/errors/exception.dart';
import 'package:reddit_reader/modules/reddit/data/datasources/reddit_post_local_data_source_impl.dart';
import 'package:reddit_reader/modules/reddit/data/models/reddit_post_list_model.dart';
import 'package:reddit_reader/modules/reddit/data/models/reddit_post_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixtures_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  RedditPostLocalDataSourceImpl redditPostLocalDataSourceImpl;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    redditPostLocalDataSourceImpl =
        RedditPostLocalDataSourceImpl(mockSharedPreferences);
  });

  group('getLastRedditPosts', () {
    final tRedditPostListModel = RedditPostListModel.fromJson(
        json.decode(fixture('reddit_post_list_cached.json')));

    test('should return cached posts when there are', () async {
      when(mockSharedPreferences.getString(cachedRedditPosts)).thenAnswer(
          (realInvocation) => fixture('reddit_post_list_cached.json'));

      final result = await redditPostLocalDataSourceImpl.getLastRedditPosts();

      verify(mockSharedPreferences.getString(cachedRedditPosts));
      expect(result, tRedditPostListModel);
    });

    test('should return CacheException when there are no posts', () async {
      when(mockSharedPreferences.getString(cachedRedditPosts))
          .thenAnswer((_) => null);

      final call = redditPostLocalDataSourceImpl.getLastRedditPosts;

      expect(() => call(), throwsA(isA<CacheException>()));
      verify(mockSharedPreferences.getString(cachedRedditPosts));
    });
  });

  group('cacheRedditPosts', () {
    final tPosts = [
      RedditPostModel(
        authorFullName: 't2_2gol75lf',
        name: 't3_j04jh3',
        subreddit: 'politics',
        title:
            'Trump and U.S. In COVID-19 crisis is \'like watching the decline of the Roman Empire\' says a Canadian mayor',
        url: 'https://www.newsweek.com/trump-coronavirus-roman-empire-1534423',
      ),
      RedditPostModel(
        authorFullName: 't2_410ho6i5',
        name: 't3_j03mj2',
        subreddit: 'NatureIsFuckingLit',
        title:
            '🔥 Whales have arm, wrist &amp; finger bones in their front fins. This is the front fin bones of a Grey whale.',
        url: 'https://i.redd.it/zkqy139mwgp51.jpg',
      )
    ];
    final tRedditPostListModel = RedditPostListModel(posts: tPosts);

    test('should call SharedPrefs setString', () async {
      redditPostLocalDataSourceImpl.cacheRedditPosts(tRedditPostListModel);
      final expectedJson = json.encode(tRedditPostListModel.toJson());

      verify(mockSharedPreferences.setString(cachedRedditPosts, expectedJson));
    });

    test('should return CacheException when there are no posts', () async {
      when(mockSharedPreferences.getString(cachedRedditPosts))
          .thenAnswer((_) => null);

      final call = redditPostLocalDataSourceImpl.getLastRedditPosts;

      expect(() => call(), throwsA(isA<CacheException>()));
      verify(mockSharedPreferences.getString(cachedRedditPosts));
    });
  });
}
