import 'package:activitypub/activitypub.dart';
import 'package:fedodo_general/Globals/general.dart';
import 'package:fedodo_micro/Components/ProfileComponents/Gallery/gallery.dart';
import 'package:fedodo_micro/Components/ProfileComponents/profile_description.dart';
import 'package:fedodo_micro/Components/ProfileComponents/profile_name_row.dart';
import 'package:fedodo_micro/Components/ProfileComponents/profile_picture_detail.dart';
import 'package:fedodo_micro/Components/PostComponents/post_list.dart';
import 'package:fedodo_micro/Enums/profile_button_state.dart';
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

class _ProfileMainState extends State<ProfileMain>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late final ActorAPI actorProvider = ActorAPI();
  late final Future<Actor> actorFuture =
      actorProvider.getActor(widget.profileId);

  int? postCount;
  int? followingCount;
  int? followersCount;

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
          if (followersCount == null && snapshot.data?.followers != null) {
            setFollowers(snapshot.data!.followers!);
          }
          if (followingCount == null && snapshot.data?.following != null) {
            setFollowings(snapshot.data!.following!);
          }
          if (postCount == null) {
            setPosts(snapshot.data!.outbox!);
          }

          var slivers = <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  ProfilePictureDetail(
                    followersCount: followersCount ?? 0,
                    followingCount: followingCount ?? 0,
                    iconUrl: snapshot.data!.icon?.url,
                    postsCount: postCount ?? 0,
                  ),
                  ProfileNameRow(
                    profileButtonInitialState:
                        getProfileButtonState(snapshot.data!),
                    preferredUsername: snapshot.data!.preferredUsername!,
                    userId: snapshot.data!.id!,
                    name: snapshot.data!.name,
                  ),
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

  Future<ProfileButtonState> getProfileButtonState(Actor actor) async {
    if (widget.profileId == General.fullActorId) {
      return ProfileButtonState.ownProfile;
    } else {
      FollowingsAPI followingsAPI = FollowingsAPI();
      var isFollowed =
          await followingsAPI.isFollowed(widget.profileId, General.fullActorId);
      if (isFollowed) {
        return ProfileButtonState.subscribed;
      } else {
        return ProfileButtonState.notSubscribed;
      }
    }
  }

  void setFollowers(String followersString) async {
    FollowersAPI followersProvider = FollowersAPI();
    OrderedPagedCollection followersCollection =
        await followersProvider.getFollowers(followersString);

    setState(() {
      followersCount = followersCollection.totalItems;
    });
  }

  void setFollowings(String followingsString) async {
    FollowingsAPI followersProvider = FollowingsAPI();
    OrderedPagedCollection followingCollection =
        await followersProvider.getFollowings(followingsString);

    setState(() {
      followingCount = followingCollection.totalItems;
    });
  }

  void setPosts(String outboxUrl) async {
    OutboxAPI outboxProvider = OutboxAPI();

    OrderedPagedCollection orderedPagedCollection =
        await outboxProvider.getFirstPage(outboxUrl);

    setState(() {
      postCount = orderedPagedCollection.totalItems;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
