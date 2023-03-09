import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../DataProvider/activity_handler.dart';
import '../../DataProvider/likes_provider.dart';
import '../../DataProvider/shares_provider.dart';
import '../../Models/ActivityPub/post.dart';
import '../../Views/PostViews/create_post.dart';

class PostBottom extends StatefulWidget {
  const PostBottom({
    Key? key,
    required this.accessToken,
    required this.post,
    required this.userId,
    required this.appTitle,
  }) : super(key: key);

  final String accessToken;
  final Post post;
  final String userId;
  final String appTitle;

  @override
  State<PostBottom> createState() => _PostBottomState();
}

class _PostBottomState extends State<PostBottom> {
  Future<bool> isPostLikedFuture = Future(() => false);
  Future<bool> isPostSharedFuture = Future(() => false);

  @override
  void initState() {
    super.initState();
    LikesProvider likesProvider = LikesProvider(widget.accessToken);
    SharesProvider sharesProvider = SharesProvider(widget.accessToken);

    isPostLikedFuture =
        likesProvider.isPostLiked(widget.post.id, widget.userId);
    isPostSharedFuture =
        sharesProvider.isPostShared(widget.post.id, widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              IconButton(
                onPressed: chatOnPressed,
                icon: const Icon(FontAwesomeIcons.comments),
              )
            ],
          ),
          Column(
            children: [
              FutureBuilder<bool>(
                future: isPostSharedFuture,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  Widget child;
                  if (snapshot.hasData) {
                    child = IconButton(
                        onPressed: announce,
                        icon: snapshot.data!
                            ? const Icon(
                                FontAwesomeIcons.retweet,
                                color: Colors.blue,
                              )
                            : const Icon(FontAwesomeIcons.retweet));
                  } else if (snapshot.hasError) {
                    child = const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    );
                  } else {
                    child = IconButton(
                      onPressed: announce,
                      icon: const Icon(
                        FontAwesomeIcons.retweet,
                      ),
                    );
                  }
                  return child;
                },
              ),
            ],
          ),
          Column(
            children: [
              FutureBuilder<bool>(
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
              ),
            ],
          ),
          Column(
            children: [
              IconButton(
                onPressed: share,
                icon: const Icon(FontAwesomeIcons.shareNodes),
              )
            ],
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

  void chatOnPressed() {
    feedbackLight();

    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, animation2) => CreatePostView(
          accessToken: widget.accessToken,
          userId: widget.userId,
          inReplyToActor: widget.post.attributedTo,
          inReplyToPost: widget.post.id,
          appTitle: widget.appTitle,
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

    Share.share("Checkout this post on Fedodo. ${widget.post.id} \n\n");
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

  void announce() async {
    bool canVibrate = await Vibrate.canVibrate;

    if (canVibrate) {
      Vibrate.feedback(FeedbackType.light);
    }

    setState(() {
      isPostSharedFuture = Future.value(true);
    });

    ActivityHandler activityHandler = ActivityHandler(widget.accessToken);
    activityHandler.share(widget.post.id);
  }
}
