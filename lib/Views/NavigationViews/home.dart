import 'package:fedodo_micro/DataProvider/inbox_provider.dart';
import 'package:fedodo_micro/Models/ActivityPub/ordered_collection.dart';
import 'package:fedodo_micro/Views/post.dart';
import 'package:flutter/material.dart';

import '../../Models/ActivityPub/post.dart';

class Home extends StatefulWidget {
  Home({
    Key? key,
    required this.accessToken,
    required this.appTitle,
  }) : super(key: key);

  final String accessToken;
  final String appTitle;

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
                ),
              );
            }
          }
          child = RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView(
              children: posts,
            ),
          );
        } else if (snapshot.hasError) {
          child = const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          );
        } else {
          child = const SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(),
          );
        }
        return child;
      },
    );
  }
}
