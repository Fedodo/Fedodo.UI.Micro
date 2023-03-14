import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../DataProvider/activity_handler.dart';
import '../../DataProvider/shares_provider.dart';
import '../../Models/ActivityPub/post.dart';

class ShareButton extends StatefulWidget {
  const ShareButton(
      {Key? key, required this.post, required this.accessToken, required this.userId})
      : super(key: key);

  final Post post;
  final String accessToken;
  final String userId;

  @override
  State<ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<ShareButton> {
  Future<bool> isPostSharedFuture = Future(() => false);

  @override
  void initState() {
    super.initState();
    SharesProvider sharesProvider = SharesProvider(widget.accessToken);

    isPostSharedFuture =
        sharesProvider.isPostShared(widget.post.id, widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
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
    );
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
