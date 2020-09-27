import 'package:reddit_reader/core/errors/exception.dart';
import 'package:reddit_reader/core/network/network_info.dart';
import 'package:reddit_reader/modules/reddit/data/datasources/reddit_post_local_data_source.dart';
import 'package:reddit_reader/modules/reddit/data/datasources/reddit_post_remote_data_source.dart';
import 'package:reddit_reader/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:reddit_reader/modules/reddit/domain/entities/reddit_post_list.dart';
import 'package:reddit_reader/modules/reddit/domain/repositories/reddit_post_repository.dart';

typedef Future<RedditPostList> _MethodChooser();

class RedditPostRepositoryImpl extends RedditPostRepository {
  final RedditPostRemoteDataSource remoteDataSource;
  final RedditPostLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  RedditPostRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, RedditPostList>> getBestRedditPosts() async {
    return await _getRedditPosts(() => remoteDataSource.getBestRedditPosts());
  }

  @override
  Future<Either<Failure, RedditPostList>> getRedditPosts(
      String subreddit) async {
    return await _getRedditPosts(
        () => remoteDataSource.getRedditPosts(subreddit));
  }

  Future<Either<Failure, RedditPostList>> _getRedditPosts(
      _MethodChooser getRedditPosts) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePosts = await getRedditPosts();
        localDataSource.cacheRedditPosts(remotePosts);
        return Right(remotePosts);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localPosts = await localDataSource.getLastRedditPosts();
        return Right(localPosts);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
