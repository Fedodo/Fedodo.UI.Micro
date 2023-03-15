import 'package:fedodo_micro/Components/PostComponents/post_bottom.dart';
import 'package:fedodo_micro/Components/post_head_indicator.dart';
import 'package:fedodo_micro/Components/user_header.dart';
import 'package:fedodo_micro/DataProvider/actor_provider.dart';
import 'package:fedodo_micro/Models/ActivityPub/actor.dart';
import 'package:fedodo_micro/Models/ActivityPub/post.dart';
import 'package:fedodo_micro/Views/PostViews/full_post.dart';
import 'package:fedodo_micro/Components/link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import "package:html/dom.dart" as dom;
import 'package:flutter_html/style.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:html/parser.dart' as htmlparser;
import '../../Models/ActivityPub/activity.dart';

class PostView extends StatelessWidget {
  const PostView({
    Key? key,
    this.isClickable = true,
    required this.activity,
    required this.accessToken,
    required this.appTitle,
    required this.userId,
  }) : super(key: key);

  final Activity<Post> activity;
  final String accessToken;
  final String appTitle;
  final bool isClickable;
  final String userId;

  @override
  Widget build(BuildContext context) {
    List<Widget> bottomChildren = [];
    dom.Document document = htmlparser.parse(activity.object.content);
    Widget? linkPreview = getLinkPreview(document);
    if (linkPreview != null) {
      bottomChildren.add(linkPreview);
    }

    List<Widget> children = [
      UserHeader(
        userId: activity.object.attributedTo,
        accessToken: accessToken,
        publishedDateTime: activity.published,
        appTitle: appTitle,
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
      PostBottom(
        accessToken: accessToken,
        activity: activity,
        userId: userId,
        appTitle: appTitle,
      ),
      const Divider(
        thickness: 1,
        height: 0,
      ),
    ];

    if (activity.object.inReplyTo != null) {
      ActorProvider actorProvider = ActorProvider(accessToken);
      Future<Actor> actorFuture =
          actorProvider.getActor(activity.object.attributedTo);
      children.insert(
        0,
        FutureBuilder<Actor>(
          future: actorFuture,
          builder: (BuildContext context, AsyncSnapshot<Actor> snapshot) {
            Widget child;
            if (snapshot.hasData) {
              child = PostHeadIndicator(
                  icon: FontAwesomeIcons.reply,
                  text:
                      "In reply to ${snapshot.data!.preferredUsername ?? "Unknown"}");
            } else if (snapshot.hasError) {
              child = const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              );
            } else {
              child = const PostHeadIndicator(
                text: "In reply to Unknown",
                icon: FontAwesomeIcons.reply,
              );
            }
            return child;
          },
        ),
      );
    }

    if (activity.type == "Announce") {
      ActorProvider actorProvider = ActorProvider(accessToken);
      Future<Actor> actorFuture = actorProvider.getActor(activity.actor);
      children.insert(
        0,
        FutureBuilder<Actor>(
          future: actorFuture,
          builder: (BuildContext context, AsyncSnapshot<Actor> snapshot) {
            Widget child;
            if (snapshot.hasData) {
              child = PostHeadIndicator(
                  icon: FontAwesomeIcons.retweet,
                  text:
                      "${snapshot.data!.preferredUsername ?? "Unknown"} reposted this");
            } else if (snapshot.hasError) {
              child = const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              );
            } else {
              child = const PostHeadIndicator(
                text: "Unknown reposted this",
                icon: FontAwesomeIcons.retweet,
              );
            }
            return child;
          },
        ),
      );
    }

    return InkWell(
      onTap: () => {openPost(context)},
      child: Ink(
        child: Column(
          children: children,
        ),
      ),
    );
  }

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

  void feedbackSelect() async {
    bool canVibrate = await Vibrate.canVibrate;

    if (canVibrate) {
      Vibrate.feedback(FeedbackType.selection);
    }
  }

  void openPost(BuildContext context) {
    feedbackSelect();

    if (isClickable) {
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, animation2) => FullPostView(
            activity: activity,
            userId: userId,
            accessToken: accessToken,
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
  }
}
