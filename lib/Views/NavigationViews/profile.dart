import 'package:activitypub/activitypub.dart';
import 'package:fedodo_micro/Components/ProfileComponents/profile_main.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({
    Key? key,
    required this.appTitle,
    required this.profileId,
    required this.showAppBar,
  }) : super(key: key);

  final String appTitle;
  final String profileId;
  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<OrderedPagedCollection>(
      future: getFirstPageAsync(),
      builder: (BuildContext outboxContext,
          AsyncSnapshot<OrderedPagedCollection> outboxSnapshot) {
        Widget child;
        if (outboxSnapshot.hasData) {
          child = ProfileMain(
            outboxUrl: outboxSnapshot.data!.first ?? "",
            profileId: profileId,
            appTitle: appTitle,
            showAppBar: showAppBar,
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
  }

  Future<OrderedPagedCollection> getFirstPageAsync() async {
    ActorAPI actorProvider = ActorAPI();
    Actor actor = await actorProvider.getActor(profileId);

    OutboxAPI outboxAPI = OutboxAPI();
    var firstPage = await outboxAPI.getFirstPage(actor.outbox!);
    
    return firstPage;
  }
}
