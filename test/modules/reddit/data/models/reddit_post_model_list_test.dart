import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_reader/modules/reddit/data/models/reddit_post_list_model.dart';
import 'package:reddit_reader/modules/reddit/data/models/reddit_post_model.dart';
import 'package:reddit_reader/modules/reddit/domain/entities/reddit_post_list.dart';

import '../../../../fixtures/fixtures_reader.dart';

void main() {
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

  test('should be a subclass of RedditPostList entity', () {
    expect(tRedditPostListModel, isA<RedditPostList>());
  });

  group('fromJson', () {
    test('should return a valid model', () {
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('reddit_post_list.json'));
      final result = RedditPostListModel.fromJson(jsonMap);
      expect(result, tRedditPostListModel);
    });
  });

  group('toJson', () {
    test('should return a valid json', () {
      final expectedJson = {
        "data": {
          "children": [
            {
              "data": {
                "subreddit": "politics",
                "author_fullname": "t2_2gol75lf",
                "title":
                    "Trump and U.S. In COVID-19 crisis is 'like watching the decline of the Roman Empire' says a Canadian mayor",
                "name": "t3_j04jh3",
                "url":
                    "https://www.newsweek.com/trump-coronavirus-roman-empire-1534423"
              }
            },
            {
              "data": {
                "subreddit": "NatureIsFuckingLit",
                "author_fullname": "t2_410ho6i5",
                "title":
                    "🔥 Whales have arm, wrist &amp; finger bones in their front fins. This is the front fin bones of a Grey whale.",
                "name": "t3_j03mj2",
                "url": "https://i.redd.it/zkqy139mwgp51.jpg"
              }
            }
          ]
        }
      };
      final result = tRedditPostListModel.toJson();
      expect(result, expectedJson);
    });
  });
}
