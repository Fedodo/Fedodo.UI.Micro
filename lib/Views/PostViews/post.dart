import 'package:fedodo_micro/Components/reply_indicator.dart';
import 'package:fedodo_micro/Components/user_header.dart';
import 'package:fedodo_micro/DataProvider/activity_handler.dart';
import 'package:fedodo_micro/DataProvider/actor_provider.dart';
import 'package:fedodo_micro/DataProvider/likes_provider.dart';
import 'package:fedodo_micro/DataProvider/shares_provider.dart';
import 'package:fedodo_micro/Models/ActivityPub/actor.dart';
import 'package:fedodo_micro/Models/ActivityPub/post.dart';
import 'package:fedodo_micro/Views/PostViews/create_post.dart';
import 'package:fedodo_micro/Views/PostViews/full_post.dart';
import 'package:fedodo_micro/Components/link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import "package:html/dom.dart" as dom;
import 'package:html/parser.dart' as htmlparser;
import 'package:flutter_html/style.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class PostView extends StatefulWidget {
  const PostView({
    Key? key,
    this.isClickable = true,
    required this.post,
    required this.accessToken,
    required this.appTitle,
    required this.userId,
  }) : super(key: key);

  final Post post;
  final String accessToken;
  final String appTitle;
  final bool isClickable;
  final String userId;

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  Future<bool> isPostLikedFuture = Future(() => false);
  Future<bool> isPostSharedFuture = Future(() => false);

  Widget? getLinkPreview(dom.Document document) {
    List<dom.Element> elements = document.getElementsByTagName("html a");

    List<String> links = [];

    for (var element in elements) {
      links.add(element.text);
    }

    if (links.isNotEmpty) {
      // Get last element which does not start with # or @
      Iterable<String> filteredLinks = links.where(
          (element) => !element.startsWith("#") && !element.startsWith("@"));

      if (filteredLinks.isNotEmpty) {
        LinkPreview linkPreview = LinkPreview(link: filteredLinks.last);
        return linkPreview;
      }

      return null;
    }

    return null;
  }

  void feedbackSelect() async{
    bool canVibrate = await Vibrate.canVibrate;

    if (canVibrate){
      Vibrate.feedback(FeedbackType.selection);
    }
  }

  void openPost() {

    feedbackSelect();

    if (widget.isClickable) {
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, animation2) => FullPostView(
            post: widget.post,
            userId: widget.userId,
            accessToken: widget.accessToken,
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
  }

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
    dom.Document document = htmlparser.parse(widget.post.content);

    List<Widget> bottomChildren = [];
    Widget? linkPreview = getLinkPreview(document);
    if (linkPreview != null) {
      bottomChildren.add(linkPreview);
    }

    List<Widget> children = [
      UserHeader(
        userId: widget.post.attributedTo,
        accessToken: widget.accessToken,
        publishedDateTime: widget.post.published,
        appTitle: widget.appTitle,
      ),
      Html(
        data: document.outerHtml,
        style: {
          "p": Style(fontSize: const FontSize(16)),
          "a": Style(
            fontSize: const FontSize(16),
            textDecoration: TextDecoration.none,
          ),
        },
        customRender: {
          "a": (RenderContext context, Widget child) {
            return InkWell(
              onTap: () => {
                launchUrl(Uri.parse(context.tree.element!.attributes["href"]!))
              },
              child: child,
            );
          },
        },
      ),
      Row(
        children: bottomChildren,
      ),
      Padding(
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
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
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
                      child = const Icon(FontAwesomeIcons.retweet);
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
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
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
                      child = const Icon(FontAwesomeIcons.star);
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
      ),
      const Divider(
        thickness: 1,
        height: 0,
      ),
    ];

    ActorProvider actorProvider = ActorProvider(widget.accessToken);
    Future<Actor> actorFuture =
        actorProvider.getActor(widget.post.attributedTo);

    if (widget.post.inReplyTo != null) {
      children.insert(
        0,
        FutureBuilder<Actor>(
          future: actorFuture,
          builder: (BuildContext context, AsyncSnapshot<Actor> snapshot) {
            Widget child;
            if (snapshot.hasData) {
              child = ReplyIndicator(
                  actorName: snapshot.data!.preferredUsername ?? "Unknown");
            } else if (snapshot.hasError) {
              child = const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              );
            } else {
              child = const ReplyIndicator(actorName: "Unknown");
            }
            return child;
          },
        ),
      );
    }

    return InkWell(
      onTap: openPost,
      child: Ink(
        child: Column(
          children: children,
        ),
      ),
    );
  }

  void feedbackLight() async {
    bool canVibrate = await Vibrate.canVibrate;

    if (canVibrate){
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

    if (canVibrate){
      Vibrate.feedback(FeedbackType.light);
    }

    Share.share("Checkout this post on Fedodo. ${widget.post.id} \n\n");
  }

  void like() async {

    bool canVibrate = await Vibrate.canVibrate;

    if (canVibrate){
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

    if (canVibrate){
      Vibrate.feedback(FeedbackType.light);
    }

    setState(() {
      isPostSharedFuture = Future.value(true);
    });

    ActivityHandler activityHandler = ActivityHandler(widget.accessToken);
    activityHandler.share(widget.post.id);
  }
}
