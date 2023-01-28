import 'package:fedodo_micro/NavigationViews/home.dart';
import 'package:fedodo_micro/NavigationViews/profile.dart';
import 'package:fedodo_micro/NavigationViews/search.dart';
import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key, required this.title, required this.accessToken});

  final String title;
  final String accessToken;

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentIndex = 0;

  void createPost() {}

  void changeMenu(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List screens = [
      Home(accessToken: widget.accessToken),
      Search(accessToken: widget.accessToken),
      Profile(accessToken: widget.accessToken)
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: changeMenu,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.contacts), label: "Profile"),
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
