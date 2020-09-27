import 'package:dartz/dartz.dart';
import 'package:reddit_reader/core/errors/failure.dart';
import 'package:reddit_reader/modules/reddit/domain/entities/reddit_post_list.dart';

abstract class RedditPostRepository {
  Future<Either<Failure, RedditPostList>> getRedditPosts(String subreddit);
  Future<Either<Failure, RedditPostList>> getBestRedditPosts();
}