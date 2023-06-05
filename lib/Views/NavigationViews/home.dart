import 'package:fedodo_micro/Components/PostComponents/post_list.dart';
import 'package:flutter/material.dart';
import '../../Globals/general.dart';
import '../../Globals/preferences.dart';

class Home extends StatelessWidget {
  const Home({
    Key? key,
    required this.appTitle,
    required this.scrollController,
  }) : super(key: key);

  final String appTitle;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return PostList(
      scrollController: scrollController,
      appTitle: appTitle,
      isInbox: true,
      noReplies: true,
      firstPage: "https://${Preferences.prefs!.getString("DomainName")}/inbox/${General.actorId}/page/0",
    );
  }
}
