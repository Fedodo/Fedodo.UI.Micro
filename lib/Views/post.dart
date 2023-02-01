import 'package:fedodo_micro/DataProvider/actor_provider.dart';
import 'package:fedodo_micro/Models/ActivityPub/actor.dart';
import 'package:fedodo_micro/Models/ActivityPub/post.dart';
import 'package:fedodo_micro/Views/link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import "package:html/dom.dart" as dom;
import 'package:html/parser.dart' as htmlparser;
import 'package:flutter_html/style.dart'; // For using CSS

class PostView extends StatefulWidget {
  const PostView({Key? key, required this.post, required this.accessToken})
      : super(key: key);

  final Post post;
  final String accessToken;

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  Widget? getLinkPreview(dom.Document document) {
    List<dom.Element> elements = document.getElementsByTagName("html a");

    List<String> links = [];

    for (var element in elements) {
      links.add(element.text);
    }

    if (links.isNotEmpty) {
      // Get last element which does not start with # or @
      Iterable<String> filteredLinks = links
          .where(
              (element) => !element.startsWith("#") && !element.startsWith("@"));

      if (filteredLinks.isNotEmpty) {
        LinkPreview linkPreview = LinkPreview(link: filteredLinks.last);
        return linkPreview;
      }

      return null;
    }

    return null;
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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
          child: FutureBuilder<Actor>(
            future: actorFuture,
            builder: (BuildContext context, AsyncSnapshot<Actor> snapshot) {
              Widget child;
              if (snapshot.hasData) {
                child = Row(
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
                            "@${snapshot.data!.preferredUsername!}@${Uri.parse(snapshot.data!.id!).authority}",
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white54),
                          ),
                        ],
                      ),
                    ),
                  ],
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
          onLinkTap: onLinkTab,
          style: {
            "p": Style(fontSize: const FontSize(16)),
            "a": Style(fontSize: const FontSize(16)),
          },
        ),
        Row(
          children: bottomChildren,
        ),
        Row(
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
                IconButton(
                  onPressed: chatOnPressed,
                  icon: const Icon(FontAwesomeIcons.retweet),
                )
              ],
            ),
            Column(
              children: [
                IconButton(
                  onPressed: chatOnPressed,
                  icon: const Icon(FontAwesomeIcons.star),
                )
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
        const Divider(
          thickness: 1,
        ),
      ],
    );
  }

  void onLinkTab(String? url, RenderContext context,
      Map<String, String> attributes, dom.Element? element) {}

  void chatOnPressed() {}
}
