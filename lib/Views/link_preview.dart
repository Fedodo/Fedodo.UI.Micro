import 'package:flutter/material.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkPreview extends StatefulWidget {
  const LinkPreview({Key? key, required this.link}) : super(key: key);

  final String link;

  @override
  State<LinkPreview> createState() => _LinkPreviewState();
}

class _LinkPreviewState extends State<LinkPreview> {
  linkPreviewPressed() async {
    bool couldLaunchUrl = await canLaunchUrl(Uri.parse(widget.link));
  }

  @override
  Widget build(BuildContext context) {
    Future<Metadata?> dataFuture = MetadataFetch.extract(widget.link);

    return FutureBuilder<Metadata?>(
      future: dataFuture,
      builder: (BuildContext context, AsyncSnapshot<Metadata?> snapshot) {
        Widget child;
        if (snapshot.hasData) {
          child = InkWell(
            onTap: linkPreviewPressed,
            child: Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: Image.network(
                    snapshot.data!.image!,
                    alignment: Alignment.center,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  color: const Color.fromARGB(210, 7, 5, 5),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Text(
                          snapshot.data!.title!,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          Uri.parse(widget.link).authority,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 13, color: Colors.white54),
                        ),
                      ],
                    ),
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
    );
  }
}
