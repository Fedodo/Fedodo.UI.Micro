import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import '../DataProvider/actor_provider.dart';
import '../Models/ActivityPub/actor.dart';

class ProfileComponent extends StatefulWidget {
  ProfileComponent({
    Key? key,
    required this.accessToken,
    required this.userId,
  }) : super(key: key);

  final String accessToken;
  final String userId;

  int postsCount = 0;
  int followingCount = 0;
  int followersCount = 0;

  @override
  State<ProfileComponent> createState() => _ProfileComponentState();
}

class _ProfileComponentState extends State<ProfileComponent>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
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
          String fullUserName =
              "@${snapshot.data!.preferredUsername!}@${Uri.parse(snapshot.data!.id!).authority}";

          child = Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            width: 80,
                            height: 80,
                            snapshot.data?.icon?.url ??
                                "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png?20170328184010",
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                widget.postsCount.toString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text("Posts"),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                widget.followingCount.toString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text("Following"),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                widget.followersCount.toString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text("Followers"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data?.name ?? "",
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          fullUserName,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Text("Do Something"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Html(
                    data: snapshot.data?.summary ?? "",
                    style: {
                      "p": Style(fontSize: const FontSize(16)),
                      "a": Style(
                        fontSize: const FontSize(16),
                        textDecoration: TextDecoration.none,
                      ),
                    },
                    customRender: {
                      "a": (RenderContext context, Widget child) {
                        return InkWell(
                          onTap: () => {
                            launchUrl(Uri.parse(
                                context.tree.element!.attributes["href"]!))
                          },
                          child: child,
                        );
                      },
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.30,
                          width: MediaQuery.of(context).size.width -16,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              ListView(
                                children: [
                                  Text("data"),
                                  Text("data"),
                                  Text("data"),
                                  Text("data"),
                                ],
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
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
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
}
