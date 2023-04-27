import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkPreview extends StatelessWidget {
  const LinkPreview({Key? key, required this.link}) : super(key: key);

  final String link;

  linkPreviewPressed() async {
    bool couldLaunchUrl = await canLaunchUrl(Uri.parse(link));

    if (couldLaunchUrl) {
      launchUrl(Uri.parse(link));
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<Metadata?> dataFuture =
        Future.delayed(const Duration(seconds: 1), () {
      return MetadataFetch.extract(link);
    });

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
            child = Stack(
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
                  child: InkWell(
                    onTap: linkPreviewPressed,
                  ),
                ),
                Container(
                  width: width,
                  height: 50,
                  color: const Color.fromARGB(210, 7, 5, 5),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data!.title!,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          Uri.parse(link).authority,
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
            child = Image.asset("assets/placeholder.png");
          }
          return child;
        },
      ),
    );
  }
}
