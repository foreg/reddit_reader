import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_reader/app_bloc_observer.dart';
import 'package:reddit_reader/injection_container.dart';
import 'package:reddit_reader/modules/reddit/presentation/pages/reddit_post_list_page.dart';

void main() async {
  EquatableConfig.stringify = true;
  Bloc.observer = AppBlocObserber();
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reddit posts',
      home: RedditPostListPage(),
    );
  }
}