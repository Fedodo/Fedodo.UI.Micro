import 'package:fedodo_micro/Models/ActivityPub/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import "package:html/dom.dart" as dom;
import 'package:html/parser.dart' as htmlparser;

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

    List<dom.Element> paragraphs = document.getElementsByTagName("p");

    // for (var element in paragraphs){
    //   element.attributes.addEntries(newEntries)
    // }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
          child: Text(
            widget.post.attributedTo,
            style: const TextStyle(fontSize: 20),
          ),
        ),
        Html(
          data: document.outerHtml,
          onLinkTap: onLinkTab,
        ),
      ],
    );
  }

  void onLinkTab(String? url, RenderContext context, Map<String, String> attributes, dom.Element? element) {
  }
}
