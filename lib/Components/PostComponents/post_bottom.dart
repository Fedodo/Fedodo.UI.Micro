import 'package:fedodo_micro/Components/PostComponents/like_button.dart';
import 'package:fedodo_micro/Components/PostComponents/share_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../Models/ActivityPub/activity.dart';
import '../../Views/PostViews/create_post.dart';

class PostBottom extends StatelessWidget {
  const PostBottom({
    Key? key,
    required this.activity,
    required this.appTitle,
  }) : super(key: key);

  final Activity activity;
  final String appTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () => {chatOnPressed(context)},
            icon: const Icon(FontAwesomeIcons.comments),
          ),
          ShareButton(
            activity: activity,
          ),
          LikeButton(
            activity: activity,
          ),
          IconButton(
            onPressed: share,
            icon: const Icon(FontAwesomeIcons.shareNodes),
          ),
        ],
      ),
    );
  }

  void feedbackLight() async {
    bool canVibrate = await Vibrate.canVibrate;

    if (canVibrate) {
      Vibrate.feedback(FeedbackType.light);
    }
  }

  void chatOnPressed(BuildContext context) {
    feedbackLight();

    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, animation2) => CreatePostView(
          inReplyToActor: activity.object.attributedTo,
          inReplyToPost: activity.object.id,
          appTitle: appTitle,
        ),
        transitionsBuilder: (context, animation, animation2, widget) =>
            SlideTransition(
                position: Tween(
                  begin: const Offset(1.0, 0.0),
                  end: const Offset(0.0, 0.0),
                ).animate(animation),
                child: widget),
      ),
    );
  }

  void share() async {
    bool canVibrate = await Vibrate.canVibrate;

    if (canVibrate) {
      Vibrate.feedback(FeedbackType.light);
    }

    Share.share("Checkout this post on Fedodo. ${activity.object.id} \n\n");
  }
}
