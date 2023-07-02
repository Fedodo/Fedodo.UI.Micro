import 'package:fedodo_general/Globals/general.dart';
import 'package:fedodo_general/Globals/preferences.dart';
import 'package:fedodo_general/Widgets/search.dart';
import 'package:fedodo_general/navigation.dart' as general;
import 'package:fedodo_micro/Components/NavigationComponents/switch_actor_button.dart';
import 'package:fedodo_micro/Views/NavigationViews/home.dart';
import 'package:fedodo_micro/Views/NavigationViews/profile.dart';
import 'package:fedodo_micro/Views/PostViews/create_post.dart';
import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  const Navigation({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  final ScrollController scrollController = ScrollController();
  String firstPage =
      "https://${Preferences.prefs!.getString("DomainName")}/inbox/${General.actorId}/page/0";
  String profileId = General.fullActorId;

  @override
  Widget build(BuildContext context) {
    return general.Navigation(
      floatingActionButton: FloatingActionButton(
        onPressed: createPost,
        tooltip: 'Create Post',
        child: const Icon(Icons.create),
      ),
      title: widget.title,
      inputScreens: [
        Home(
          scrollController: scrollController,
          appTitle: widget.title,
          firstPage: firstPage,
        ),
        Search(
          getProfile: (String profileId) {
            return Profile(
              profileId: profileId,
              showAppBar: true,
            );
          },
        ),
        Profile(
          key: Key(profileId),
          profileId: profileId,
          showAppBar: false,
        ),
      ],
      appBarActions: [
        SwitchActorButton(
          reloadState: () {
            setState(() {
              firstPage =
                  "https://${Preferences.prefs!.getString("DomainName")}/inbox/${General.actorId}/page/0";
              profileId = General.fullActorId;
            });
          },
        ),
      ],
      bottomNavigationBarItems: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
      scrollController: scrollController,
    );
  }

  void createPost() {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, animation2) => CreatePostView(
          // post: widget.post,
          appTitle: widget.title,
          // replies: widget.replies,
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
