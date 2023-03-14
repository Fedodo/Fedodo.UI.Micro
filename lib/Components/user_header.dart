import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../DataProvider/actor_provider.dart';
import '../Models/ActivityPub/actor.dart';
import '../Views/NavigationViews/profile.dart';

class UserHeader extends StatelessWidget {
  const UserHeader({
    Key? key,
    required this.userId,
    required this.accessToken,
    required this.appTitle,
    this.publishedDateTime,
  }) : super(key: key);

  final String accessToken;
  final String userId;
  final DateTime? publishedDateTime;
  final String appTitle;

  @override
  Widget build(BuildContext context) {
    ActorProvider actorProvider = ActorProvider(accessToken);
    Future<Actor> actorFuture = actorProvider.getActor(userId);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
      child: FutureBuilder<Actor>(
        future: actorFuture,
        builder: (BuildContext context, AsyncSnapshot<Actor> snapshot) {
          Widget child;
          if (snapshot.hasData) {
            String text =
                "@${snapshot.data!.preferredUsername!}@${Uri.parse(snapshot.data!.id!).authority}";

            if (publishedDateTime != null) {
              text +=
                  " · ${timeago.format(publishedDateTime!, locale: "en_short").replaceAll("~", "")}";
            }

            child = InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => {openProfile(context)},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(45),
                    child: CachedNetworkImage(
                      width: 45,
                      height: 45,
                      imageUrl: snapshot.data?.icon?.url ??
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
                          text,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white54,
                          ),
                        ),
                      ],
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
            String text = "Unknown";

            if (publishedDateTime != null) {
              text +=
                  " · ${timeago.format(publishedDateTime!, locale: "en_short").replaceAll("~", "")}";
            }

            child = Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(45),
                  child: Image.asset(
                    "assets/profile.png",
                    width: 45,
                    height: 45,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Unknown",
                        style: TextStyle(fontSize: 17),
                      ),
                      Text(
                        text,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return child;
        },
      ),
    );
  }

  void openProfile(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, animation2) => Profile(
          accessToken: accessToken,
          userId: userId,
          appTitle: appTitle,
          showAppBar: true,
        ),
        transitionsBuilder: (context, animation, animation2, widget) =>
            SlideTransition(
                position: Tween(
                  begin: const Offset(1.0, 0.0),
                  end: const Offset(0.0, 0.0),
                ).animate(animation),
                child: widget),
      ),
    );
  }
}
