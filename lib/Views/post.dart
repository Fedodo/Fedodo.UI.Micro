import 'package:fedodo_micro/Models/ActivityPub/post.dart';
import 'package:flutter/material.dart';

class PostView extends StatefulWidget {
  const PostView({Key? key, required this.post}) : super(key: key);

  final Post post;

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
          child: Text(
            widget.post.attributedTo,
            style: const TextStyle(fontSize: 20),
          ),
        ),
        Text(widget.post.content),
      ],
    );
  }
}
