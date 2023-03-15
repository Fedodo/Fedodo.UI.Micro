import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../APIs/ActivityPub/likes_api.dart';
import '../../Models/ActivityPub/activity.dart';

class LikeButton extends StatefulWidget {
  const LikeButton({
    Key? key,
    required this.activity,
    required this.accessToken, required this.userId,
  }) : super(key: key);

  final Activity activity;
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
    LikesAPI likesProvider = LikesAPI(widget.accessToken);

    isPostLikedFuture =
        likesProvider.isPostLiked(widget.activity.object.id, widget.userId);
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

    LikesAPI likesAPI = LikesAPI(widget.accessToken);
    likesAPI.like(widget.activity.object.id);
  }
}
