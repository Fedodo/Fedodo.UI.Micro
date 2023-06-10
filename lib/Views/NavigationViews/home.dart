import 'package:fedodo_micro/Components/PostComponents/post_list.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({
    Key? key,
    required this.appTitle,
    required this.scrollController,
    required this.firstPage,
  }) : super(key: key);

  final String appTitle;
  final String firstPage;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return PostList(
      key: Key(firstPage),
      scrollController: scrollController,
      appTitle: appTitle,
      isInbox: true,
      noReplies: true,
      firstPage: firstPage,
    );
  }
}
