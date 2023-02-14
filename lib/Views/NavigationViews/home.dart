import 'package:fedodo_micro/DataProvider/inbox_provider.dart';
import 'package:fedodo_micro/Models/ActivityPub/ordered_collection.dart';
import 'package:fedodo_micro/Views/PostViews/post.dart';
import 'package:flutter/material.dart';

import '../../Models/ActivityPub/post.dart';

class Home extends StatefulWidget {
  Home({
    Key? key,
    required this.accessToken,
    required this.appTitle,
    required this.userId,
  }) : super(key: key);

  final String accessToken;
  final String appTitle;
  final String userId;

  late InboxProvider provider;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<OrderedCollection<Post>> collectionFuture;

  Future<OrderedCollection<Post>> onRefresh() {
    Future<OrderedCollection<Post>> refreshFuture = widget.provider.getPosts();

    setState(() {
      collectionFuture = refreshFuture;
    });

    return refreshFuture;
  }

  @override
  Widget build(BuildContext context) {
    widget.provider = InboxProvider(widget.accessToken);

    collectionFuture = widget.provider.getPosts();

    return FutureBuilder<OrderedCollection<Post>>(
      future: collectionFuture,
      builder: (BuildContext context,
          AsyncSnapshot<OrderedCollection<Post>> snapshot) {
        Widget child;
        if (snapshot.hasData) {
          List<Widget> posts = [];
          for (var element in snapshot.data!.orderedItems) {
            if (element.inReplyTo == null || element.inReplyTo!.isEmpty) {
              // TODO Add reply's of people you follow
              posts.add(
                PostView(
                  post: element,
                  accessToken: widget.accessToken,
                  appTitle: widget.appTitle,
                  replies: snapshot.data!.orderedItems
                      .where((e) => e.inReplyTo == element.id)
                      .toList(),
                  userId: widget.userId,
                ),
              );
            }
          }
          child = RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (BuildContext context, int index) {
                return posts[index];
              },
            ),
          );
        } else if (snapshot.hasError) {
          child = const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          );
        } else {
          child = const Center(
            child: SizedBox(
              width: 200,
              height: 200,
              child: CircularProgressIndicator(),
            ),
          );
        }
        return child;
      },
    );
  }
}
