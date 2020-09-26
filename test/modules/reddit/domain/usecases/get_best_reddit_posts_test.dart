import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reddit_reader/core/usecases/usecase.dart';
import 'package:reddit_reader/modules/reddit/domain/entities/reddit_post.dart';
import 'package:reddit_reader/modules/reddit/domain/repositories/reddit_post_repository.dart';
import 'package:reddit_reader/modules/reddit/domain/usecases/get_best_reddit_posts.dart';

class RedditPostRepositoryMock extends Mock implements RedditPostRepository {}

void main() {
  GetBestRedditPosts usecase;
  RedditPostRepositoryMock redditPostRepositoryMock;

  setUp(() {
    redditPostRepositoryMock = RedditPostRepositoryMock();
    usecase = GetBestRedditPosts(redditPostRepositoryMock);
  });

  final tRedditPosts = [
    RedditPost(
      authorFullName: 'authorFullName',
      name: 'name',
      subreddit: 'subreddit',
      title: 'best title',
      url: 'url',
    ),
    RedditPost(
      authorFullName: 'authorFullName',
      name: 'name',
      subreddit: 'subreddit',
      title: 'best1 title',
      url: 'url',
    ),
  ];

  test('should get best reddit posts from the repository', () async {
    when(redditPostRepositoryMock.getBestRedditPosts())
        .thenAnswer((_) async => Right(tRedditPosts));
    final result = await usecase(NoParams());
    expect(result, Right(tRedditPosts));
    verify(redditPostRepositoryMock.getBestRedditPosts());
    verifyNoMoreInteractions(redditPostRepositoryMock);
  });
}
