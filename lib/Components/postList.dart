import 'package:fedodo_micro/DataProvider/inbox_provider.dart';
import 'package:fedodo_micro/Models/ActivityPub/ordered_collection_page.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../DataProvider/outbox_provider.dart';
import '../Models/ActivityPub/activity.dart';
import '../Models/ActivityPub/post.dart';
import '../Views/PostViews/post.dart';

class PostList extends StatefulWidget {
  const PostList({
    Key? key,
    required this.accessToken,
    required this.appTitle,
    required this.userId,
    required this.firstPage,
    this.noReplies = false,
    this.isInbox = true,
  }) : super(key: key);

  final String accessToken;
  final String appTitle;
  final String userId;
  final String firstPage;
  final bool noReplies;
  final bool isInbox;

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  late final PagingController<String, Post> _paginationController = PagingController(firstPageKey: widget.firstPage);
  static const _pageSize = 20;

  @override
  void initState() {
    _paginationController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    super.initState();
  }

  Future<void> _fetchPage(String pageKey) async {
    try {
      OrderedCollectionPage orderedCollectionPage;

      if (widget.isInbox){
        InboxProvider inboxProvider = InboxProvider(widget.accessToken);
        orderedCollectionPage = await inboxProvider.getPosts(pageKey);
      }else {
        OutboxProvider provider = OutboxProvider();
        orderedCollectionPage = await provider.getPosts(pageKey);
      }

      List<Activity<Post>> postActivities = [];

      for (Activity activity in orderedCollectionPage.orderedItems) {
        if (widget.noReplies){
          if (activity.type == "Create" && activity.object.inReplyTo == null) {
            postActivities.add(activity as Activity<Post>);
          }
        }else{
          if (activity.type == "Create") {
            postActivities.add(activity as Activity<Post>);
          }
        }
      }

      final orderedItems = postActivities;

      List<Post> newItems = [];

      for (Activity<Post> activity in orderedItems) {
        newItems.add(activity.object);
      }

      final isLastPage = orderedCollectionPage.orderedItems.length < _pageSize;
      if (isLastPage) {
        _paginationController.appendLastPage(newItems);
      } else {
        final nextPageKey = orderedCollectionPage.next;
        _paginationController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _paginationController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Future.sync(
        () => _paginationController.refresh(),
      ),
      child: PagedListView<String, Post>(
        cacheExtent: 0,
        clipBehavior: Clip.none,
        pagingController: _paginationController,
        builderDelegate: PagedChildBuilderDelegate<Post>(
          itemBuilder: (context, item, index) => PostView(
            post: item,
            accessToken: widget.accessToken,
            appTitle: widget.appTitle,
            userId: widget.userId,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _paginationController.dispose();
    super.dispose();
  }
}
