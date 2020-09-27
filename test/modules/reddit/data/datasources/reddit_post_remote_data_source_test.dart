import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:reddit_reader/core/errors/exception.dart';
import 'package:reddit_reader/modules/reddit/data/datasources/reddit_post_remote_data_source_impl.dart';
import 'package:reddit_reader/modules/reddit/data/models/reddit_post_list_model.dart';

import '../../../../fixtures/fixtures_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  RedditPostRemoteDataSourceImpl redditPostRemoteDataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    redditPostRemoteDataSource = RedditPostRemoteDataSourceImpl(mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(fixture('reddit_post_list.json'), 200,
            headers: {'content-type': 'application/json; charset=UTF-8'}));
  }

  void setUpMockHttpClientSuccess404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('404', 404));
  }

  group('getRedditPosts', () {
    final tSubreddit = 'Flutter';
    final tRedditPostListModel = RedditPostListModel.fromJson(
        json.decode(fixture('reddit_post_list.json')));

    test('should send get request', () async {
      setUpMockHttpClientSuccess200();

      await redditPostRemoteDataSource.getRedditPosts(tSubreddit);

      verify(mockHttpClient.get(
        redditApiUrl + 'r/$tSubreddit.json',
        headers: {'content-type': 'application/json; charset=UTF-8'},
      ));
    });

    test('should return Reddit Post List Model when 200', () async {
      setUpMockHttpClientSuccess200();

      final result =
          await redditPostRemoteDataSource.getRedditPosts(tSubreddit);
      expect(result, tRedditPostListModel);
    });

    test('should return ServerException when there are no posts', () async {
      setUpMockHttpClientSuccess404();

      final call = redditPostRemoteDataSource.getRedditPosts;

      expect(() => call(tSubreddit), throwsA(isA<ServerException>()));
    });
  });

  group('getBestRedditPosts', () {
    final tRedditPostListModel = RedditPostListModel.fromJson(
        json.decode(fixture('reddit_post_list.json')));

    test('should send get request', () async {
      setUpMockHttpClientSuccess200();

      await redditPostRemoteDataSource.getBestRedditPosts();

      verify(mockHttpClient.get(
        redditApiUrl + 'best.json',
        headers: {'content-type': 'application/json; charset=UTF-8'},
      ));
    });

    test('should return Reddit Post List Model when 200', () async {
      setUpMockHttpClientSuccess200();

      final result =
          await redditPostRemoteDataSource.getBestRedditPosts();
      expect(result, tRedditPostListModel);
    });

    test('should return ServerException when there are no posts', () async {
      setUpMockHttpClientSuccess404();

      final call = redditPostRemoteDataSource.getBestRedditPosts;

      expect(() => call(), throwsA(isA<ServerException>()));
    });
  });
}
