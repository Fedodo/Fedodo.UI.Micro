import 'package:activitypub/activitypub.dart';
import 'package:fedodo_general/globals/general.dart';
import 'package:fedodo_general/logic/vibrate.dart';
import 'package:fedodo_general/widgets/posts/components/post_bottom.dart';
import 'package:fedodo_general/widgets/posts/components/user_header.dart';
import 'package:fedodo_micro/Components/PostComponents/BottomChildren/bottom_children_image.dart';
import 'package:fedodo_micro/Components/PostComponents/post_head_indicator.dart';
import 'package:fedodo_micro/Views/NavigationViews/profile.dart';
import 'package:fedodo_micro/Views/PostViews/create_post.dart';
import 'package:fedodo_micro/Views/PostViews/full_post.dart';
import 'package:fedodo_micro/Components/PostComponents/link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import "package:html/dom.dart" as dom;
import 'package:url_launcher/url_launcher.dart';
import 'package:html/parser.dart' as htmlparser;

class PostView extends StatelessWidget {
  const PostView({
    Key? key,
    this.isClickable = true,
    required this.activity,
  }) : super(key: key);

  final Activity<Post> activity;
  final bool isClickable;

  @override
  Widget build(BuildContext context) {
    List<Widget> bottomChildren = [];

    dom.Document document = htmlparser.parse(activity.object.content);

    if (activity.object.attachment?.isNotEmpty ?? false) {
      for (var item in activity.object.attachment!) {
        bottomChildren.add(
          BottomChildrenImage(
            url: item.url!.toString(),
            appTitle: General.appName,
            noPadding: activity.object.attachment!.length != 1 ? false : true,
          ),
        );
      }
    } else {
      Widget? linkPreview = getLinkPreview(document);
      if (linkPreview != null) {
        bottomChildren.add(linkPreview);
      }
    }

    List<Widget> children = [
      UserHeader(
        profileId: activity.object.attributedTo,
        publishedDateTime: activity.published,
        profile: Profile(
          profileId: activity.object.attributedTo,
          showAppBar: true,
        ),
      ),
      Html(
        data: document.outerHtml,
        style: {
          "p": Style(
            fontSize: FontSize(16),
          ),
          "a": Style(
            fontSize: FontSize(16),
            textDecoration: TextDecoration.none,
          ),
        },
        extensions: [
          TagExtension(
            tagsToExtend: {"a"},
            builder: (extensionContext) {
              return InkWell(
                onTap: () => {
                  launchUrl(
                    Uri.parse(
                      extensionContext.element!.attributes["href"]!,
                    ),
                  ),
                },
                child: Text(
                  extensionContext.node.text!,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      Row(
        children: bottomChildren,
      ),
      PostBottom(
        activity: activity,
        createPostView: const CreatePostView(),
      ),
      const Divider(
        thickness: 1,
        height: 0,
      ),
    ];

    if (activity.object.inReplyTo != null) {
      ActorAPI actorProvider = ActorAPI();
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
      ActorAPI actorProvider = ActorAPI();
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

  void openPost(BuildContext context) {
    VibrateFeedback.feedbackSelect();

    if (isClickable) {
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, animation2) => FullPostView(
            activity: activity,
            appTitle: General.appName,
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
