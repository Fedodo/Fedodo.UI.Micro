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
    required this.outboxUrl,
    this.noReplies = false,
  }) : super(key: key);

  final String accessToken;
  final String appTitle;
  final String userId;
  final String outboxUrl;
  final bool noReplies;

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> with TickerProviderStateMixin {
  late final PagingController<String, Post> _noRepliesController =
      PagingController(firstPageKey: widget.outboxUrl);
  static const _pageSize = 20;

  @override
  void initState() {
    _noRepliesController.addPageRequestListener((pageKey) {
      _fetchPageNoReplies(pageKey);
    });

    super.initState();
  }

  Future<void> _fetchPageNoReplies(String pageKey) async {
    try {
      OutboxProvider provider = OutboxProvider();

      final collection = await provider.getPosts(pageKey);

      List<Activity<Post>> postActivities = [];

      for (Activity activity in collection.orderedItems) {
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

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _noRepliesController.appendLastPage(newItems);
      } else {
        final nextPageKey = collection.next;
        _noRepliesController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _noRepliesController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView<String, Post>(
      pagingController: _noRepliesController,
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
    );
  }

  @override
  void dispose() {
    _noRepliesController.dispose();
    super.dispose();
  }
}
