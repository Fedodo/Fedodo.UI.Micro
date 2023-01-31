import 'package:fedodo_micro/DataProvider/inbox_provider.dart';
import 'package:fedodo_micro/Models/ActivityPub/ordered_collection.dart';
import 'package:fedodo_micro/Views/post.dart';
import 'package:flutter/material.dart';

import '../../Models/ActivityPub/post.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.accessToken}) : super(key: key);

  final String accessToken;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    InboxProvider provider = InboxProvider(widget.accessToken);

    Future<OrderedCollection<Post>> collectionFuture = provider.getPosts();

    return FutureBuilder<OrderedCollection<Post>>(
      future: collectionFuture,
      builder: (BuildContext context,
          AsyncSnapshot<OrderedCollection<Post>> snapshot) {
        Widget child;
        if (snapshot.hasData) {
          List<Widget> posts = [];
          for (var element in snapshot.data!.orderedItems) {
            posts.add(
              PostView(
                post: element,
                accessToken: widget.accessToken,
              ),
            );
          }

          child = ListView(
            children: posts,
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
