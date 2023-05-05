import 'package:fedodo_micro/Views/NavigationViews/home.dart';
import 'package:fedodo_micro/Views/NavigationViews/profile.dart';
import 'package:fedodo_micro/Views/NavigationViews/search.dart';
import 'package:fedodo_micro/Views/PostViews/create_post.dart';
import 'package:fedodo_micro/global_settings.dart';
import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  const Navigation({
    super.key,
    required this.title,
    required this.domainName,
  });

  final String title;
  final String domainName;

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
          domainName: widget.domainName,
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

  @override
  Widget build(BuildContext context) {
    List screens = [
      Home(
        scrollController: controller,
        appTitle: widget.title,
        domainName: widget.domainName,
      ),
      Search(),
      Search(), // TODO
      Profile(
        appTitle: widget.title,
        profileId: "https://${widget.domainName}/actor/${GlobalSettings.userId}",
        showAppBar: false,
        domainName: widget.domainName,
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
