import 'package:fedodo_micro/Views/post.dart';
import 'package:flutter/material.dart';

import '../Models/ActivityPub/post.dart';

class FullPostView extends StatefulWidget {
  const FullPostView({
    Key? key,
    required this.post,
    required this.accessToken,
    required this.appTitle,
  }) : super(key: key);

  final Post post;
  final String accessToken;
  final String appTitle;

  @override
  State<FullPostView> createState() => _FullPostViewState();
}

class _FullPostViewState extends State<FullPostView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appTitle),
      ),
      body: PostView(
        isClickable: false,
        post: widget.post,
        accessToken: widget.accessToken,
        appTitle: widget.appTitle,
      ),
    );
  }
}
