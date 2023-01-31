import 'package:fedodo_micro/Models/ActivityPub/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import "package:html/dom.dart" as dom;
import 'package:html/parser.dart' as htmlparser;
import 'package:flutter_html/style.dart'; // For using CSS

class PostView extends StatefulWidget {
  const PostView({Key? key, required this.post}) : super(key: key);

  final Post post;

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  @override
  Widget build(BuildContext context) {
    dom.Document document = htmlparser.parse(widget.post.content);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  width: 50,
                  height: 50,
                  "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png?20170328184010",
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "LNA-DEV",
                      style: TextStyle(fontSize: 17),
                    ),
                    Text(
                      "@lna_dev@mastodon.online",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white54),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Html(
          data: document.outerHtml,
          onLinkTap: onLinkTab,
          style: {"p": Style(fontSize: const FontSize(18))},
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
