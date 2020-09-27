import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reddit_reader/modules/reddit/domain/entities/reddit_post.dart';
import 'package:reddit_reader/modules/reddit/domain/entities/reddit_post_list.dart';
import 'package:reddit_reader/modules/reddit/domain/repositories/reddit_post_repository.dart';
import 'package:reddit_reader/modules/reddit/domain/usecases/get_sub_reddit_posts.dart';

class RedditPostRepositoryMock extends Mock implements RedditPostRepository {}

void main() {
  GetSubRedditPosts usecase;
  RedditPostRepositoryMock redditPostRepositoryMock;

  setUp(() {
    redditPostRepositoryMock = RedditPostRepositoryMock();
    usecase = GetSubRedditPosts(redditPostRepositoryMock);
  });

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

  test('should get sub reddit posts from the repository', () async {
    when(redditPostRepositoryMock.getRedditPosts(tSubreddit))
        .thenAnswer((_) async => Right(tRedditPostList));
    final result = await usecase(Params(subreddit: tSubreddit));
    expect(result, Right(tRedditPostList));
    verify(redditPostRepositoryMock.getRedditPosts(tSubreddit));
    verifyNoMoreInteractions(redditPostRepositoryMock);
  });
}
