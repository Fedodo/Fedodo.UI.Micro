import 'package:cached_network_image/cached_network_image.dart';
import 'package:fedodo_micro/Extensions/string_extensions.dart';
import 'package:flutter/material.dart';
import '../../ProfileComponents/Gallery/photo_detail.dart';

class BottomChildrenImage extends StatelessWidget {
  const BottomChildrenImage({
    Key? key,
    required this.url,
    required this.appTitle,
    this.noPadding = false,
  }) : super(key: key);

  final String url;
  final String appTitle;
  final bool noPadding;

  @override
  Widget build(BuildContext context) {

    double padding = 4;

    if(noPadding){
      padding = 0;
    }

    return Expanded(
      child: Padding(
        padding: EdgeInsets.fromLTRB(padding, 0, padding, 0),
        child: SizedBox(
          height: 200,
          child: Ink.image(
            fit: BoxFit.cover,
            image: CachedNetworkImageProvider(url.asProxyString()),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 300),
                    reverseTransitionDuration:
                        const Duration(milliseconds: 300),
                    pageBuilder: (context, animation, animation2) =>
                        PhotoDetail(title: appTitle, url: url.asProxyString()),
                    transitionsBuilder:
                        (context, animation, animation2, widget) =>
                            SlideTransition(
                                position: Tween(
                                  begin: const Offset(1.0, 0.0),
                                  end: const Offset(0.0, 0.0),
                                ).animate(animation),
                                child: widget),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
