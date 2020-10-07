import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:reddit_reader/core/network/network_info.dart';
import 'package:reddit_reader/core/network/network_info_impl.dart';
import 'package:reddit_reader/core/utils/input_converter.dart';
import 'package:reddit_reader/modules/reddit/data/datasources/reddit_post_local_data_source.dart';
import 'package:reddit_reader/modules/reddit/data/datasources/reddit_post_local_data_source_impl.dart';
import 'package:reddit_reader/modules/reddit/data/datasources/reddit_post_remote_data_source.dart';
import 'package:reddit_reader/modules/reddit/data/datasources/reddit_post_remote_data_source_impl.dart';
import 'package:reddit_reader/modules/reddit/data/repositories/reddit_post_repository_impl.dart';
import 'package:reddit_reader/modules/reddit/domain/repositories/reddit_post_repository.dart';
import 'package:reddit_reader/modules/reddit/domain/usecases/get_best_reddit_posts.dart';
import 'package:reddit_reader/modules/reddit/domain/usecases/get_sub_reddit_posts.dart';
import 'package:reddit_reader/modules/reddit/presentation/bloc/reddit_post_list_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _registerExternalPackages();
  _registerCore();
  _registerReddit();
}

void _registerCore() {
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
}

Future<void> _registerExternalPackages() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}

void _registerReddit() {
  _registerDataSourcesReddit();
  _registerRepositoryReddit();
  _registerUseCasesReddit();
  _registerBlocReddit();
}

void _registerBlocReddit() {
  sl.registerLazySingleton(
    () => RedditPostListBloc(
      getBestRedditPosts: sl(),
      getSubRedditPosts: sl(),
      inputConvertor: sl(),
    ),
  );
}

void _registerUseCasesReddit() {
  sl.registerLazySingleton(() => GetBestRedditPosts(sl()));
  sl.registerLazySingleton(() => GetSubRedditPosts(sl()));
}

void _registerRepositoryReddit() {
  sl.registerLazySingleton<RedditPostRepository>(
    () => RedditPostRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
}

void _registerDataSourcesReddit() {
  sl.registerLazySingleton<RedditPostRemoteDataSource>(() => RedditPostRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<RedditPostLocalDataSource>(() => RedditPostLocalDataSourceImpl(sl()));
}