import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fedodo_general/extensions/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkPreview extends StatelessWidget {
  const LinkPreview({
    Key? key,
    required this.link,
  }) : super(key: key);

  final String link;

  @override
  Widget build(BuildContext context) {
    Future<Metadata?> dataFuture =
        MetadataFetch.extract(link.asFedodoProxyString());

    var width = MediaQuery.of(context).size.width;

    return Expanded(
      child: SizedBox(
        height: 200,
        child: FutureBuilder<Metadata?>(
          future: dataFuture,
          builder: (BuildContext context, AsyncSnapshot<Metadata?> snapshot) {
            Widget child;
            if (snapshot.hasData &&
                snapshot.data!.title != null &&
                snapshot.data!.url != null &&
                snapshot.data!.image != null) {
              child = Column(
                children: [
                  Ink.image(
                    height: 150,
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                        snapshot.data!.image!.asFedodoProxyString()),
                    child: InkWell(
                      onTap: linkPreviewPressed,
                    ),
                  ),
                  Container(
                    width: width,
                    height: 50,
                    color: const Color.fromARGB(255, 0, 0, 0),
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
              child = const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
              child = const Center(
                child: SizedBox(
                  width: 45,
                  height: 45,
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return child;
          },
        ),
      ),
    );
  }

  linkPreviewPressed() async {
    bool couldLaunchUrl = await canLaunchUrl(Uri.parse(link));

    if (couldLaunchUrl) {
      launchUrl(Uri.parse(link));
    }
  }
}
