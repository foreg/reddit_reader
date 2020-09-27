import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_reader/modules/reddit/data/models/reddit_post_model.dart';
import 'package:reddit_reader/modules/reddit/domain/entities/reddit_post.dart';

import '../../../../fixtures/fixtures_reader.dart';

void main() {
  final tRedditPostModel = RedditPostModel(
    authorFullName: 't2_2gol75lf',
    name: 't3_j04jh3',
    subreddit: 'politics',
    title:
        'Trump and U.S. In COVID-19 crisis is \'like watching the decline of the Roman Empire\' says a Canadian mayor',
    url: 'https://www.newsweek.com/trump-coronavirus-roman-empire-1534423',
  );

  test('should be a subclass of RedditPost entity', () {
    expect(tRedditPostModel, isA<RedditPost>());
  });

  group('fromJson', () {
    test('should return a valid model', () {
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('reddit_post.json'));
      final result = RedditPostModel.fromJson(jsonMap);
      expect(result, tRedditPostModel);
    });
  });

  group('toJson', () {
    test('should return a valid json', () {
      final expectedJson = {
        "data": {
          "subreddit": "politics",
          "author_fullname": "t2_2gol75lf",
          "title": "Trump and U.S. In COVID-19 crisis is \'like watching the decline of the Roman Empire\' says a Canadian mayor",
          "name": "t3_j04jh3",
          "url": "https://www.newsweek.com/trump-coronavirus-roman-empire-1534423",
        }
      };
      final result = tRedditPostModel.toJson();
      expect(result, expectedJson);
    });
  });
}
