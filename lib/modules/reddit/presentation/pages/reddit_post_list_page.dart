import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_reader/injection_container.dart';
import 'package:reddit_reader/modules/reddit/presentation/bloc/reddit_post_list_bloc.dart';

class RedditPostListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (context) => sl<RedditPostListBloc>(),
          child: Column(
            children: [
              RaisedButton(
                onPressed: () => sl<RedditPostListBloc>().add(
                  GetBestRedditPostsEvent(),
                ),
              ),
              Container(
                height: 500,
                child: BlocBuilder<RedditPostListBloc, RedditPostListState>(
                  builder: (context, state) {
                    if (state is Empty) {
                      return Text('Empty');
                    } else if (state is Loading) {
                      return CircularProgressIndicator();
                    } else if (state is Error) {
                      return Text(state.message);
                    } else if (state is Loaded) {
                      return ListView.builder(
                        itemCount: state.redditPostList.posts.length,
                        itemBuilder: (context, index) => ListTile(
                          title: Text(state.redditPostList.posts[index].title),
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
