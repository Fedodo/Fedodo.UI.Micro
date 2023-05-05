import 'package:fedodo_micro/global_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../APIs/ActivityPub/shares_api.dart';
import '../../Models/ActivityPub/activity.dart';

class ShareButton extends StatefulWidget {
  const ShareButton({
    Key? key,
    required this.activity,
    required this.domainName,
  }) : super(key: key);

  final Activity activity;
  final String domainName;

  @override
  State<ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<ShareButton> {
  Future<bool> isPostSharedFuture = Future(() => false);

  @override
  void initState() {
    super.initState();
    SharesAPI sharesProvider = SharesAPI(
      widget.domainName,
      GlobalSettings.userId
    );

    isPostSharedFuture =
        sharesProvider.isPostShared(widget.activity.object.id, GlobalSettings.userId);
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

    SharesAPI sharesAPI = SharesAPI(
      widget.domainName,
      GlobalSettings.userId,
    );
    sharesAPI.share(widget.activity.object.id);
  }
}
