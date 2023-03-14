import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../DataProvider/activity_handler.dart';
import '../../DataProvider/likes_provider.dart';
import '../../Models/ActivityPub/post.dart';

class LikeButton extends StatefulWidget {
  const LikeButton({
    Key? key,
    required this.post,
    required this.accessToken, required this.userId,
  }) : super(key: key);

  final Post post;
  final String accessToken;
  final String userId;

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  Future<bool> isPostLikedFuture = Future(() => false);

  @override
  void initState() {
    super.initState();
    LikesProvider likesProvider = LikesProvider(widget.accessToken);

    isPostLikedFuture =
        likesProvider.isPostLiked(widget.post.id, widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isPostLikedFuture,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        Widget child;
        if (snapshot.hasData) {
          child = IconButton(
              onPressed: like,
              icon: snapshot.data!
                  ? const Icon(
                      FontAwesomeIcons.solidStar,
                      color: Colors.orangeAccent,
                    )
                  : const Icon(FontAwesomeIcons.star));
        } else if (snapshot.hasError) {
          child = const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          );
        } else {
          child = IconButton(
            onPressed: like,
            icon: const Icon(
              FontAwesomeIcons.star,
            ),
          );
        }
        return child;
      },
    );
  }

  void like() async {
    bool canVibrate = await Vibrate.canVibrate;

    if (canVibrate) {
      Vibrate.feedback(FeedbackType.light);
    }

    setState(() {
      isPostLikedFuture = Future.value(true);
    });

    ActivityHandler activityHandler = ActivityHandler(widget.accessToken);
    activityHandler.like(widget.post.id);
  }
}
