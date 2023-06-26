import 'package:activitypub/APIs/actor_api.dart';
import 'package:activitypub/Models/actor.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fedodo_general/Extensions/string_extensions.dart';
import 'package:fedodo_general/Globals/general.dart';
import 'package:fedodo_general/Globals/preferences.dart';
import 'package:fedodo_micro/Components/NavigationComponents/custom_popup_menu_item.dart';
import 'package:fedodo_micro/Views/create_actor_view.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SwitchActorButton extends StatefulWidget {
  const SwitchActorButton({
    Key? key,
    required this.reloadState,
  }) : super(key: key);

  final Function reloadState;

  @override
  State<SwitchActorButton> createState() => _SwitchActorButtonState();
}

class _SwitchActorButtonState extends State<SwitchActorButton> {
  @override
  Widget build(BuildContext context) {
    var actorsFuture = getActors();

    return FutureBuilder<List<Actor>>(
      future: actorsFuture,
      builder: (BuildContext context, AsyncSnapshot<List<Actor>> snapshot) {
        Widget child;
        if (snapshot.hasData) {
          child = Theme(
            data: Theme.of(context).copyWith(
              highlightColor: Colors.lightBlue,
            ),
            child: PopupMenuButton<int>(
              onSelected: (int index) {
                if (index >= snapshot.data!.length) {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 300),
                      reverseTransitionDuration:
                          const Duration(milliseconds: 300),
                      pageBuilder: (context, animation, animation2) =>
                          CreateActorView(),
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

                  return;
                }

                var actor = snapshot.data![index];

                setState(() {
                  General.actorId = actor.id!.split("/").last;
                });

                widget.reloadState();
              },
              tooltip: "Switch Profile",
              icon: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  width: 30,
                  height: 30,
                  imageUrl: snapshot.data
                          ?.where(
                              (element) => element.id == General.fullActorId)
                          .first
                          .icon
                          ?.url
                          .asFedodoProxyString() ??
                      "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png?20170328184010"
                          .asFedodoProxyString(),
                ),
              ),
              itemBuilder: (BuildContext context) {
                List<PopupMenuItem<int>> widgets = [];

                int count = 0;
                for (var element in snapshot.data!) {
                  widgets.add(
                    CustomPopupMenuItem(
                      value: count,
                      color: General.fullActorId == snapshot.data![count].id
                          ? Colors.black26
                          : null,
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedNetworkImage(
                              width: 30,
                              height: 30,
                              imageUrl: element.icon?.url
                                      .asFedodoProxyString() ??
                                  "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png?20170328184010"
                                      .asFedodoProxyString(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                            child: Text(
                              element.preferredUsername ?? "Unknown",
                            ),
                          ),
                        ],
                      ),
                    ),
                  );

                  count++;
                }

                widgets.add(
                  PopupMenuItem(
                    value: count,
                    child: const Row(
                      children: [
                        Icon(Icons.add),
                        Text("Create Profile"),
                      ],
                    ),
                  ),
                );

                return widgets;
              },
            ),
          );
        } else if (snapshot.hasError) {
          child = const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          );
        } else {
          child = const CircularProgressIndicator();
        }
        return child;
      },
    );
  }

  Future<List<Actor>> getActors() async {
    var token = JwtDecoder.decode(Preferences.prefs!.getString("AccessToken")!);
    String userId = token["sub"];

    ActorAPI actorAPI = ActorAPI();
    List<String> actorsList = await actorAPI.getAllActorsOfUser(userId);

    List<Actor> actors = [];
    var domainName = Preferences.prefs!.getString("DomainName");

    for (var element in actorsList) {
      var actor = await actorAPI.getActor("https://$domainName/actor/$element");
      actors.add(actor);
    }

    return actors;
  }
}
