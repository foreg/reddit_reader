import 'package:dartz/dartz.dart';
import 'package:reddit_reader/core/errors/failure.dart';
import 'package:reddit_reader/modules/reddit/domain/entities/reddit_post.dart';

abstract class RedditPostRepository {
  Future<Either<Failure, List<RedditPost>>> getRedditPosts(String subreddit);
  Future<Either<Failure, List<RedditPost>>> getBestRedditPosts();
}