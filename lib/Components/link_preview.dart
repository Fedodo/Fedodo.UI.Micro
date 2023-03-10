import 'package:cached_network_image/cached_network_image.dart';
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

    if (couldLaunchUrl) {
      launchUrl(Uri.parse(widget.link));
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<Metadata?> dataFuture = MetadataFetch.extract(widget.link);

    var width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 200,
      width: width,
      child: FutureBuilder<Metadata?>(
        future: dataFuture,
        builder: (BuildContext context, AsyncSnapshot<Metadata?> snapshot) {
          Widget child;
          if (snapshot.hasData &&
              snapshot.data!.title != null &&
              snapshot.data!.url != null &&
              snapshot.data!.image != null) {
            child = InkWell(
              onTap: linkPreviewPressed,
              child: Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Ink.image(
                    width: width,
                    height: 200,
                    alignment: Alignment.center,
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                      snapshot.data!.image!,
                      maxHeight: 200,
                      maxWidth: width.round(),
                    ),
                  ),
                  Container(
                    width: width,
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
                              fontSize: 13,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError || snapshot.hasData) {
            child = Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 100,
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Could not load Link Preview"),
                ),
              ],
            );
          } else {
            child = InkWell(
              onTap: linkPreviewPressed,
              child: Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Ink.image(
                    width: width,
                    height: 200,
                    alignment: Alignment.center,
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                      "https://upload.wikimedia.org/wikipedia/commons/0/0e/DefaultImage.png",
                      maxWidth: width.round(),
                      maxHeight: 200,
                    ),
                  ),
                  Container(
                    width: width,
                    height: 50,
                    color: const Color.fromARGB(210, 7, 5, 5),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                      child: ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          Text(
                            Uri.parse(widget.link).authority,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            Uri.parse(widget.link).authority,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return child;
        },
      ),
    );
  }
}
