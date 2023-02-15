import 'package:fedodo_micro/Components/icon_bar.dart';
import 'package:fedodo_micro/DataProvider/likes_provider.dart';
import 'package:fedodo_micro/DataProvider/shares_provider.dart';
import 'package:fedodo_micro/Models/ActivityPub/ordered_collection.dart';
import 'package:fedodo_micro/Views/PostViews/post.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../Models/ActivityPub/post.dart';

class FullPostView extends StatefulWidget {
  const FullPostView({
    Key? key,
    required this.post,
    required this.accessToken,
    required this.appTitle,
    required this.replies,
    required this.userId,
  }) : super(key: key);

  final Post post;
  final String accessToken;
  final String appTitle;
  final List<Post> replies;
  final String userId;

  @override
  State<FullPostView> createState() => _FullPostViewState();
}

class _FullPostViewState extends State<FullPostView> {
  @override
  Widget build(BuildContext context) {
    LikesProvider likesProv = LikesProvider(widget.accessToken);
    SharesProvider sharesProvider = SharesProvider(widget.accessToken);

    var likesFuture = likesProv.getLikes(widget.post.id);
    var sharesFuture = sharesProvider.getShares(widget.post.id);

    List<Widget> children = [];
    children.addAll(
      [
        PostView(
          isClickable: false,
          post: widget.post,
          accessToken: widget.accessToken,
          appTitle: widget.appTitle,
          replies: const [], // TODO
          userId: widget.userId,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 8, 8),
          child: Column(
            children: [
              FutureBuilder<OrderedCollection<String>>(
                future: sharesFuture,
                builder: (BuildContext context,
                    AsyncSnapshot<OrderedCollection<String>> snapshot) {
                  Widget child;
                  if (snapshot.hasData) {
                    child = IconBar(
                      name: "Reblogs",
                      count: snapshot.data!.totalItems,
                      iconData: FontAwesomeIcons.retweet,
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
              ),
              FutureBuilder<OrderedCollection<String>>(
                future: likesFuture,
                builder: (BuildContext context,
                    AsyncSnapshot<OrderedCollection<String>> snapshot) {
                  Widget child;
                  if (snapshot.hasData) {
                    child = IconBar(
                      name: "Likes",
                      count: snapshot.data!.totalItems,
                      iconData: FontAwesomeIcons.star,
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
              ),
              Row(
                children: [
                  Text(
                    DateFormat("MMMM d, yyyy HH:mm", "en_us").format(
                        widget.post.published.toLocal()), // TODO Internationalization
                    style: const TextStyle(
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(
          thickness: 1,
          height: 0, // TODO ?
        ),
      ],
    );

    for (var element in widget.replies) {
      children.add(
        PostView(
          post: element,
          accessToken: widget.accessToken,
          appTitle: widget.appTitle,
          userId: widget.userId,
          replies: const [], // TODO
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appTitle),
      ),
      body: ListView(
        children: children,
      ),
    );
  }
}
