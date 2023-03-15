import 'package:fedodo_micro/APIs/ActivityPub/actor_api.dart';
import 'package:fedodo_micro/Models/ActivityPub/ordered_paged_collection.dart';
import 'package:fedodo_micro/Components/ProfileComponents/profile_main.dart';
import 'package:flutter/material.dart';
import '../../APIs/ActivityPub/outbox_api.dart';
import '../../Models/ActivityPub/actor.dart';

class Profile extends StatefulWidget {
  const Profile({
    Key? key,
    required this.accessToken,
    required this.appTitle,
    required this.userId,
    required this.showAppBar,
  }) : super(key: key);

  final String accessToken;
  final String appTitle;
  final String userId;
  final bool showAppBar;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    ActorAPI actorProvider = ActorAPI(widget.accessToken);

    return FutureBuilder<Actor>(
      future: actorProvider.getActor(widget.userId),
      builder: (BuildContext context, AsyncSnapshot<Actor> snapshot) {
        Widget child;
        if (snapshot.hasData) {
          OutboxAPI provider = OutboxAPI();

          child = FutureBuilder<OrderedPagedCollection>(
            future: provider.getFirstPage(snapshot.data?.outbox ?? ""),
            builder: (BuildContext outboxContext, AsyncSnapshot<OrderedPagedCollection> outboxSnapshot) {
              Widget child;
              if (outboxSnapshot.hasData) {
                child = ProfileMain(
                  outboxUrl: outboxSnapshot.data?.first ?? "",
                  accessToken: widget.accessToken,
                  userId: widget.userId,
                  appTitle: widget.appTitle,
                  showAppBar: widget.showAppBar,
                );
              } else if (outboxSnapshot.hasError) {
                child = const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
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
          );
        } else if (snapshot.hasError) {
          child = const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
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
    );
  }
}
