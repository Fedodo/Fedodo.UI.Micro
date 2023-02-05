import 'package:fedodo_micro/Components/icon_bar.dart';
import 'package:fedodo_micro/Views/post.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../Models/ActivityPub/post.dart';

class FullPostView extends StatefulWidget {
  const FullPostView({
    Key? key,
    required this.post,
    required this.accessToken,
    required this.appTitle,
    required this.replies,
  }) : super(key: key);

  final Post post;
  final String accessToken;
  final String appTitle;
  final List<Post> replies;

  @override
  State<FullPostView> createState() => _FullPostViewState();
}

class _FullPostViewState extends State<FullPostView> {
  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    children.addAll(
      [
        PostView(
          isClickable: false,
          post: widget.post,
          accessToken: widget.accessToken,
          appTitle: widget.appTitle,
          replies: const [],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 8, 8),
          child: Column(
            children: [
              const IconBar(
                name: "Reblogs",
                count: 0, // TODO
                iconData: FontAwesomeIcons.retweet,
              ),
              const IconBar(
                name: "Likes",
                count: 0, // TODO
                iconData: FontAwesomeIcons.star,
              ),
              Row(
                children: [
                  Text(
                    DateFormat("MMMM d, yyyy HH:mm", "en_us").format(
                        widget.post.published), // TODO Internationalization
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
          replies: const [],
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
