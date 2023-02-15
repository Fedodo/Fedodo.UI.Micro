import 'dart:ffi';

import 'package:fedodo_micro/Components/reply_indicator.dart';
import 'package:fedodo_micro/DataProvider/activity_handler.dart';
import 'package:fedodo_micro/DataProvider/actor_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../Components/user_header.dart';
import '../../Models/ActivityPub/actor.dart';

class CreatePostView extends StatefulWidget {
  CreatePostView({
    Key? key,
    required this.userId,
    required this.accessToken,
    this.inReplyToActor,
    this.inReplyToPost,
  }) : super(key: key);

  final String userId;
  final String accessToken;

  String? inReplyToPost;
  String? inReplyToActor;
  Function()? buttonFunction;

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [
      UserHeader(userId: widget.userId, accessToken: widget.accessToken),
      Expanded(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLines: null,
              onChanged: (String text) {
                if (text != "") {
                  setState(() {
                    widget.buttonFunction = () {
                      ActivityHandler activityHandler =
                          ActivityHandler(widget.accessToken);
                      activityHandler.post(text, widget.inReplyToPost);

                      Navigator.pop(context);
                    };
                  });
                } else {
                  setState(() {
                    widget.buttonFunction = null;
                  });
                }
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Here you can type and paste freely',
              ),
            ),
          ),
        ),
      ),
    ];

    if (widget.inReplyToActor != null) {
      ActorProvider actorProvider = ActorProvider(widget.accessToken);
      Future<Actor> actorFuture = actorProvider.getActor(widget.inReplyToActor!);
      widgets.insert(
        0,
        FutureBuilder<Actor>(
          future: actorFuture,
          builder: (BuildContext context, AsyncSnapshot<Actor> snapshot) {
            Widget child;
            if (snapshot.hasData) {
              child = ReplyIndicator(
                actorName:
                    snapshot.data?.name ?? snapshot.data?.preferredUsername ?? "Unknown User",
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
                  width: 45,
                  height: 45,
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return child;
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(FontAwesomeIcons.xmark),
        ),
        actions: [
          ElevatedButton(
            onPressed: widget.buttonFunction,
            child: const Text("Publish"),
          ),
        ],
      ),
      body: Column(
        children: widgets,
      ),
    );
  }
}
