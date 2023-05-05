import 'package:fedodo_micro/Components/PostComponents/post_list.dart';
import 'package:flutter/material.dart';

import '../../global_settings.dart';

class Home extends StatelessWidget {
  const Home({
    Key? key,
    required this.accessToken,
    required this.appTitle,
    required this.domainName,
    required this.scrollController,
  }) : super(key: key);

  final String accessToken;
  final String appTitle;
  final String domainName;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return PostList(
      scrollController: scrollController,
      accessToken: accessToken,
      appTitle: appTitle,
      isInbox: true,
      noReplies: true,
      firstPage: "https://$domainName/inbox/${GlobalSettings.userId}/page/0",
      domainName: domainName,
    );
  }
}
