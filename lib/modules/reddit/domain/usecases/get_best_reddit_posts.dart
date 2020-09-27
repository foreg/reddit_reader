import 'package:dartz/dartz.dart';
import 'package:reddit_reader/core/errors/failure.dart';
import 'package:reddit_reader/core/usecases/usecase.dart';
import 'package:reddit_reader/modules/reddit/domain/entities/reddit_post_list.dart';
import 'package:reddit_reader/modules/reddit/domain/repositories/reddit_post_repository.dart';

class GetBestRedditPosts extends UseCase<RedditPostList, NoParams> {
  final RedditPostRepository redditPostRepository;

  GetBestRedditPosts(this.redditPostRepository);

  Future<Either<Failure, RedditPostList>> call(NoParams noParams) async {
    return await redditPostRepository.getBestRedditPosts();
  }
}