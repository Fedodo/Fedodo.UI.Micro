import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileDescription extends StatelessWidget {
  const ProfileDescription({
    Key? key,
    this.htmlData,
  }) : super(key: key);

  final String? htmlData;

  @override
  Widget build(BuildContext context) {
    return Html(
      data: htmlData ?? "",
      style: {
        "p": Style(fontSize: FontSize(16)),
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
    );
  }
}
