import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:fedodo_micro/Views/NavigationViews/home.dart';
import 'package:fedodo_micro/Views/NavigationViews/profile.dart';
import 'package:fedodo_micro/Views/NavigationViews/search.dart';
import 'package:fedodo_micro/Views/PostViews/create_post.dart';
import 'package:flutter/material.dart';

import '../Globals/preferences.dart';

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
  int currentIndex = 0;
  final ScrollController controller = ScrollController();

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

  void changeMenu(int index) {
    if (currentIndex == 0 && index == 0) {
      controller.animateTo(
        0,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    }

    setState(() {
      currentIndex = index;
    });
  }

  SideMenuController sideMenuController = SideMenuController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    if (width > height && width >= 600) {
      EdgeInsets paddings = EdgeInsets.fromLTRB(width * 0.1, 0, width * 0.1, 0);

      List screens = [
        Padding(
          padding: paddings,
          child: Home(
            scrollController: controller,
            appTitle: widget.title,
          ),
        ),
        Padding(
          padding: paddings,
          child: Search(),
        ),
        Padding(
          padding: paddings,
          child: Search(),
        ), // TODO
        Padding(
          padding: paddings,
          child: Profile(
            appTitle: widget.title,
            profileId: Preferences.prefs!.getString("ActorId")!,
            showAppBar: false,
          ),
        ),
      ];

      sideMenuController.changePage(currentIndex);

      List<SideMenuItem> items = [
        SideMenuItem(
          priority: 0,
          title: 'Home',
          onTap: (int index, SideMenuController controller) {
            setState(() {
              currentIndex = index;
            });
          },
          icon: const Icon(Icons.home),
        ),
        SideMenuItem(
          priority: 1,
          title: 'Search',
          onTap: (int index, SideMenuController controller) {
            setState(() {
              currentIndex = index;
            });
          },
          icon: const Icon(Icons.search),
        ),
        SideMenuItem(
          priority: 2,
          title: 'Notifications',
          onTap: (int index, SideMenuController controller) {
            setState(() {
              currentIndex = index;
            });
          },
          icon: const Icon(Icons.notifications),
        ),
        SideMenuItem(
          priority: 3,
          title: 'Profile',
          onTap: (int index, SideMenuController controller) {
            setState(() {
              currentIndex = index;
            });
          },
          icon: const Icon(Icons.person),
        ),
      ];

      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SideMenu(
                  style: SideMenuStyle(
                    displayMode: SideMenuDisplayMode.auto,
                    hoverColor: const Color.fromARGB(165, 0, 84, 84),
                    selectedColor: const Color.fromARGB(255, 0, 84, 84),
                    selectedTitleTextStyle: const TextStyle(color: Colors.white),
                    selectedIconColor: Colors.white,
                    unselectedIconColor: Colors.white70,
                    unselectedTitleTextStyle:
                        const TextStyle(color: Colors.white70),
                    backgroundColor: const Color.fromARGB(255, 1, 35, 35),
                  ),
                  footer: const Text('Fedodo'),
                  items: items,
                  controller: sideMenuController,
                ),
              ),
            ),
            Expanded(
              child: screens[currentIndex],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createPost,
          tooltip: 'Create Post',
          child: const Icon(Icons.create),
        ),
      );
    } else {
      List screens = [
        Home(
          scrollController: controller,
          appTitle: widget.title,
        ),
        Search(),
        Search(), // TODO
        Profile(
          appTitle: widget.title,
          profileId: Preferences.prefs!.getString("ActorId")!,
          showAppBar: false,
        ),
      ];

      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: changeMenu,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications), label: "Notifications"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
        body: screens[currentIndex],
        floatingActionButton: FloatingActionButton(
          onPressed: createPost,
          tooltip: 'Create Post',
          child: const Icon(Icons.create),
        ),
      );
    }
  }
}
