import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:reddit_reader/core/errors/failure.dart';
import 'package:reddit_reader/core/usecases/usecase.dart';
import 'package:reddit_reader/modules/reddit/domain/entities/reddit_post_list.dart';
import 'package:reddit_reader/modules/reddit/domain/repositories/reddit_post_repository.dart';

class GetSubRedditPosts extends UseCase<RedditPostList, Params> {
  final RedditPostRepository redditPostRepository;

  GetSubRedditPosts(this.redditPostRepository);

  Future<Either<Failure, RedditPostList>> call(Params params) async {
    return await redditPostRepository.getRedditPosts(params.subreddit);
  }
}

class Params extends Equatable {
  final String subreddit;

  Params({@required this.subreddit});

  @override
  List<Object> get props => [];
}
