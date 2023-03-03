import 'package:fedodo_micro/DataProvider/inbox_provider.dart';
import 'package:fedodo_micro/Models/ActivityPub/ordered_collection.dart';
import 'package:fedodo_micro/Views/PostViews/post.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../Models/ActivityPub/activity.dart';
import '../../Models/ActivityPub/post.dart';

class Home extends StatefulWidget {
  Home({
    Key? key,
    required this.accessToken,
    required this.appTitle,
    required this.userId,
  }) : super(key: key);

  final String accessToken;
  final String appTitle;
  final String userId;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const _pageSize = 20;
  final PagingController<int, Post> _pagingController =
      PagingController(firstPageKey: 0);

  late Future<OrderedCollection> collectionFuture;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      InboxProvider provider = InboxProvider(widget.accessToken);

      var response = (await provider.getPosts(pageKey)).orderedItems;

      List<Activity<Post>> postActivities = [];

      for (Activity activity in response){
        if (activity.type == "Create"){
          postActivities.add(activity as Activity<Post>);
        }
      }

      final orderedItems = postActivities;

      List<Post> newItems = [];

      for (Activity<Post> activity in orderedItems){
        newItems.add(activity.object);
      }

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Future.sync(
        () => _pagingController.refresh(),
      ),
      child: PagedListView<int, Post>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Post>(
          itemBuilder: (context, item, index) => PostView(
            post: item,
            accessToken: widget.accessToken,
            appTitle: widget.appTitle,
            replies: const [],
            // TODO
            userId: widget.userId,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
