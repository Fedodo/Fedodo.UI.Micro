import 'package:activitypub/activitypub.dart';
import 'package:fedodo_general/widgets/profile/profile_head.dart';
import 'package:fedodo_micro/Components/ProfileComponents/Gallery/gallery.dart';
import 'package:fedodo_micro/Components/PostComponents/post_list.dart';
import 'package:flutter/material.dart';
import 'About/about.dart';

class ProfileMain extends StatefulWidget {
  const ProfileMain({
    Key? key,
    this.showAppBar = true,
    required this.profileId,
    required this.appTitle,
    required this.outboxUrl,
  }) : super(key: key);

  final String profileId;
  final String appTitle;
  final String outboxUrl;
  final bool showAppBar;

  @override
  State<ProfileMain> createState() => _ProfileMainState();
}

class _ProfileMainState extends State<ProfileMain> with TickerProviderStateMixin {
  late TabController _tabController;
  late final ActorAPI actorProvider = ActorAPI();
  late final Future<Actor> actorFuture =
      actorProvider.getActor(widget.profileId);

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Actor>(
      future: actorFuture,
      builder: (BuildContext context, AsyncSnapshot<Actor> snapshot) {
        Widget child;
        if (snapshot.hasData) {
          var slivers = <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  ProfileHead(
                    actor: snapshot.data!,
                  ),
                ],
              ),
            ),
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              primary: false,
              pinned: true,
              automaticallyImplyLeading: false,
              title: TabBar(
                isScrollable: true,
                controller: _tabController,
                tabs: const [
                  Tab(
                    text: "Posts",
                  ),
                  Tab(
                    text: "Posts and Replies",
                  ),
                  Tab(
                    text: "Media",
                  ),
                  Tab(
                    text: "About",
                  ),
                ],
              ),
            ),
          ];

          if (widget.showAppBar) {
            slivers.insert(
              0,
              const SliverAppBar(
                primary: true,
                pinned: true,
              ),
            );
          }

          child = Scaffold(
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return slivers;
              },
              body: TabBarView(
                controller: _tabController,
                children: [
                  PostList(
                    appTitle: widget.appTitle,
                    firstPage: widget.outboxUrl,
                    noReplies: true,
                    isInbox: false,
                  ),
                  PostList(
                    appTitle: widget.appTitle,
                    firstPage: widget.outboxUrl,
                    isInbox: false,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                    child: Gallery(
                      firstPage: widget.outboxUrl,
                      isInbox: false,
                      appTitle: widget.appTitle,
                    ),
                  ),
                  About(
                    actor: snapshot.data!,
                  ),
                ],
              ),
            ),
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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
