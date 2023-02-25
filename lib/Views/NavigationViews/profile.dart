import 'package:fedodo_micro/DataProvider/actor_provider.dart';
import 'package:fedodo_micro/Models/ActivityPub/ordered_paged_collection.dart';
import 'package:fedodo_micro/Views/profile_view.dart';
import 'package:flutter/material.dart';
import '../../DataProvider/outbox_provider.dart';
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
    ActorProvider actorProvider = ActorProvider(widget.accessToken);

    return FutureBuilder<Actor>(
      future: actorProvider.getActor(widget.userId),
      builder: (BuildContext context, AsyncSnapshot<Actor> snapshot) {
        Widget child;
        if (snapshot.hasData) {
          OutboxProvider provider = OutboxProvider();

          child = FutureBuilder<OrderedPagedCollection>(
            future: provider.getFirstPage(snapshot.data?.outbox ?? ""),
            builder: (BuildContext outboxContext, AsyncSnapshot<OrderedPagedCollection> outboxSnapshot) {
              Widget child;
              if (outboxSnapshot.hasData) {
                child = ProfileView(
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
