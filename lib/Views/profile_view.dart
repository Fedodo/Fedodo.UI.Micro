import 'package:fedodo_micro/Components/ProfileComponents/profile_description.dart';
import 'package:fedodo_micro/Components/ProfileComponents/profile_name_row.dart';
import 'package:fedodo_micro/Components/ProfileComponents/profile_picture_detail.dart';
import 'package:fedodo_micro/DataProvider/followers_provider.dart';
import 'package:fedodo_micro/DataProvider/followings_provider.dart';
import 'package:flutter/material.dart';
import '../DataProvider/actor_provider.dart';
import '../DataProvider/outbox_provider.dart';
import '../Models/ActivityPub/actor.dart';
import '../Models/ActivityPub/ordered_collection.dart';
import '../Models/ActivityPub/post.dart';

class ProfileView extends StatefulWidget {
  ProfileView({
    Key? key,
    this.showAppBar = true,
    required this.accessToken,
    required this.userId,
    required this.appTitle,
  }) : super(key: key);

  final String accessToken;
  final String userId;
  final String appTitle;

  int postCount = 0;
  int followingCount = 0;
  int followersCount = 0;
  bool showAppBar = true;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  void setFollowers(String followersString) async {
    FollowersProvider followersProvider = FollowersProvider();
    OrderedCollection<Actor> followersCollection = await followersProvider.getFollowers(followersString);

    setState(() {
      widget.followersCount = followersCollection.totalItems;
    });
  }

  void setFollowings(String followingsString) async {
    FollowingProvider followersProvider = FollowingProvider();
    OrderedCollection<Actor> followingCollection = await followersProvider.getFollowings(followingsString);

    setState(() {
      widget.followingCount = followingCollection.totalItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    ActorProvider actorProvider = ActorProvider(widget.accessToken);
    Future<Actor> actorFuture = actorProvider.getActor(widget.userId);

    return FutureBuilder<Actor>(
      future: actorFuture,
      builder: (BuildContext context, AsyncSnapshot<Actor> snapshot) {
        Widget child;
        if (snapshot.hasData) {
          OutboxProvider outboxProvider = OutboxProvider(widget.accessToken);
          Future<OrderedCollection<Post>> collectionFuture =
              outboxProvider.getPosts(snapshot.data?.outbox ?? ""); // TODO

          if (snapshot.data?.followers != null) {
            setFollowers(snapshot.data!.followers!);
          }
          if (snapshot.data?.following != null) {
            setFollowings(snapshot.data!.following!);
          }

          var silvers = <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  ProfilePictureDetail(
                    followersCount: widget.followersCount,
                    followingCount: widget.followingCount,
                    iconUrl: snapshot.data!.icon?.url,
                    postsCount: widget.postCount,
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
            SliverAnimatedList(
              itemBuilder: (_, index, ___) {
                return ListTile(
                  title: Text(index.toString()),
                );
              },
              initialItemCount: 100,
            )
          ];

          if (widget.showAppBar) {
            silvers.insert(
              0,
              const SliverAppBar(
                primary: true,
                pinned: true,
              ),
            );
          }

          child = Scaffold(
            body: CustomScrollView(
              slivers: silvers,
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
