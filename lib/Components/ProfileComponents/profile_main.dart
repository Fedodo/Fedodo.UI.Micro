import 'package:fedodo_micro/Components/ProfileComponents/profile_description.dart';
import 'package:fedodo_micro/Components/ProfileComponents/profile_name_row.dart';
import 'package:fedodo_micro/Components/ProfileComponents/profile_picture_detail.dart';
import 'package:fedodo_micro/Components/PostComponents/post_list.dart';
import 'package:fedodo_micro/APIs/ActivityPub/followers_api.dart';
import 'package:fedodo_micro/APIs/ActivityPub/followings_api.dart';
import 'package:fedodo_micro/Models/ActivityPub/ordered_paged_collection.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../APIs/ActivityPub/actor_api.dart';
import '../../APIs/ActivityPub/outbox_api.dart';
import '../../Models/ActivityPub/activity.dart';
import '../../Models/ActivityPub/actor.dart';
import '../../Models/ActivityPub/ordered_collection.dart';
import '../../Models/ActivityPub/post.dart';
import '../../Views/PostViews/post.dart';

class ProfileMain extends StatefulWidget {
  ProfileMain({
    Key? key,
    this.showAppBar = true,
    required this.accessToken,
    required this.userId,
    required this.appTitle,
    required this.outboxUrl,
  }) : super(key: key);

  final String accessToken;
  final String userId;
  final String appTitle;
  final String outboxUrl;

  int? postCount;
  int? followingCount;
  int? followersCount;
  bool showAppBar = true;

  @override
  State<ProfileMain> createState() => _ProfileMainState();
}

class _ProfileMainState extends State<ProfileMain>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late final ActorAPI actorProvider = ActorAPI(widget.accessToken);
  late final Future<Actor> actorFuture = actorProvider.getActor(widget.userId);

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 4, vsync: this);
  }

  void setFollowers(String followersString) async {
    FollowersAPI followersProvider = FollowersAPI();
    OrderedPagedCollection followersCollection =
        await followersProvider.getFollowers(followersString);

    setState(() {
      widget.followersCount = followersCollection.totalItems;
    });
  }

  void setFollowings(String followingsString) async {
    FollowingsAPI followersProvider = FollowingsAPI();
    OrderedPagedCollection followingCollection =
        await followersProvider.getFollowings(followingsString);

    setState(() {
      widget.followingCount = followingCollection.totalItems;
    });
  }

  void setPosts(String outboxUrl) async {
    OutboxAPI outboxProvider = OutboxAPI();

    OrderedPagedCollection orderedPagedCollection =
        await outboxProvider.getFirstPage(outboxUrl);

    setState(() {
      widget.postCount = orderedPagedCollection.totalItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Actor>(
      future: actorFuture,
      builder: (BuildContext context, AsyncSnapshot<Actor> snapshot) {
        Widget child;
        if (snapshot.hasData) {
          if (widget.followersCount == null &&
              snapshot.data?.followers != null) {
            setFollowers(snapshot.data!.followers!);
          }
          if (widget.followingCount == null &&
              snapshot.data?.following != null) {
            setFollowings(snapshot.data!.following!);
          }
          if (widget.postCount == null) {
            setPosts(snapshot.data!.outbox!);
          }

          var slivers = <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  ProfilePictureDetail(
                    followersCount: widget.followersCount ?? 0,
                    followingCount: widget.followingCount ?? 0,
                    iconUrl: snapshot.data!.icon?.url,
                    postsCount: widget.postCount ?? 0,
                  ),
                  ProfileNameRow(
                      preferredUsername: snapshot.data!.preferredUsername!,
                      userId: snapshot.data!.id!,
                      name: snapshot.data!.name),
                  ProfileDescription(
                    htmlData: snapshot.data!.summary ?? "",
                  ),
                ],
              ),
            ),
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              primary: false,
              pinned: true,
              automaticallyImplyLeading: false,
              title: Row(
                children: <Widget>[
                  TabBar(
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
                    accessToken: widget.accessToken,
                    appTitle: widget.appTitle,
                    userId: widget.userId,
                    firstPage: widget.outboxUrl,
                    noReplies: true,
                    isInbox: false,
                  ),
                  PostList(
                    accessToken: widget.accessToken,
                    appTitle: widget.appTitle,
                    userId: widget.userId,
                    firstPage: widget.outboxUrl,
                    isInbox: false,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.blueAccent,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.blueAccent,
                    ),
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
