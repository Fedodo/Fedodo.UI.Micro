import 'package:fedodo_micro/DataProvider/activity_handler.dart';
import 'package:fedodo_micro/DataProvider/actor_provider.dart';
import 'package:fedodo_micro/DataProvider/likes_provider.dart';
import 'package:fedodo_micro/DataProvider/shares_provider.dart';
import 'package:fedodo_micro/Models/ActivityPub/actor.dart';
import 'package:fedodo_micro/Models/ActivityPub/post.dart';
import 'package:fedodo_micro/Views/full_post.dart';
import 'package:fedodo_micro/Views/link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import "package:html/dom.dart" as dom;
import 'package:html/parser.dart' as htmlparser;
import 'package:flutter_html/style.dart';
import 'package:url_launcher/url_launcher.dart'; // For using CSS
import 'package:timeago/timeago.dart' as timeago;

class PostView extends StatefulWidget {
  const PostView({
    Key? key,
    this.isClickable = true,
    required this.post,
    required this.accessToken,
    required this.appTitle,
    required this.replies,
  }) : super(key: key);

  final Post post;
  final String accessToken;
  final String appTitle;
  final bool isClickable;
  final List<Post> replies;

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

  void openPost() {
    if (widget.isClickable) {
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, animation2) => FullPostView(
            post: widget.post,
            accessToken: widget.accessToken,
            appTitle: widget.appTitle,
            replies: widget.replies,
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

  void openProfile() {}

  @override
  void initState() {
    super.initState();
    LikesProvider likesProvider = LikesProvider(widget.accessToken);
    SharesProvider sharesProvider = SharesProvider(widget.accessToken);

    isPostLikedFuture = likesProvider.isPostLiked(widget.post.id,
        "https://dev.fedodo.social/actor/e287834b-0564-4ece-b793-0ef323344959"); // TODO
    isPostSharedFuture = sharesProvider.isPostShared(widget.post.id,
        "https://dev.fedodo.social/actor/e287834b-0564-4ece-b793-0ef323344959"); // TODO
  }

  @override
  Widget build(BuildContext context) {
    dom.Document document = htmlparser.parse(widget.post.content);

    ActorProvider actorProvider = ActorProvider(widget.accessToken);

    Future<Actor> actorFuture =
        actorProvider.getActor(widget.post.attributedTo);

    List<Widget> bottomChildren = [];
    Widget? linkPreview = getLinkPreview(document);
    if (linkPreview != null) {
      bottomChildren.add(linkPreview);
    }

    return InkWell(
      onTap: openPost,
      child: Ink(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
              child: FutureBuilder<Actor>(
                future: actorFuture,
                builder: (BuildContext context, AsyncSnapshot<Actor> snapshot) {
                  Widget child;
                  if (snapshot.hasData) {
                    child = InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: openProfile,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                              width: 45,
                              height: 45,
                              snapshot.data?.icon?.url ??
                                  "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png?20170328184010",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data!.name!,
                                  style: const TextStyle(fontSize: 17),
                                ),
                                Text(
                                  "@${snapshot.data!.preferredUsername!}@${Uri.parse(snapshot.data!.id!).authority} "
                                  "· ${timeago.format(widget.post.published, locale: "en_short").replaceAll("~", "")}",
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white54),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    child = const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    );
                  } else {
                    child = const SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(),
                    );
                  }
                  return child;
                },
              ),
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
                      launchUrl(
                          Uri.parse(context.tree.element!.attributes["href"]!))
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
                        builder: (BuildContext context,
                            AsyncSnapshot<bool> snapshot) {
                          Widget child;
                          if (snapshot.hasData) {
                            child = IconButton(
                                onPressed: share,
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
                            child = const SizedBox(
                              width: 60,
                              height: 60,
                              child: CircularProgressIndicator(),
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
                        builder: (BuildContext context,
                            AsyncSnapshot<bool> snapshot) {
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
                            child = const SizedBox(
                              width: 60,
                              height: 60,
                              child: CircularProgressIndicator(),
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
                        onPressed: chatOnPressed,
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
          ],
        ),
      ),
    );
  }

  void chatOnPressed() {}

  void like() {
    setState(() {
      isPostLikedFuture = Future.value(true);
    });

    ActivityHandler activityHandler = ActivityHandler(widget.accessToken);
    activityHandler.like(widget.post.id);
  }

  void share() {
    setState(() {
      isPostSharedFuture = Future.value(true);
    });

    ActivityHandler activityHandler = ActivityHandler(widget.accessToken);
    activityHandler.share(widget.post.id);
  }
}
