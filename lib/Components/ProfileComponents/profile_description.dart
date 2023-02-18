import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileDescription extends StatefulWidget {
  const ProfileDescription({
    Key? key,
    this.htmlData,
  }) : super(key: key);

  final String? htmlData;

  @override
  State<ProfileDescription> createState() => _ProfileDescriptionState();
}

class _ProfileDescriptionState extends State<ProfileDescription> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Html(
          data: widget.htmlData ?? "",
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
      ],
    );
  }
}
