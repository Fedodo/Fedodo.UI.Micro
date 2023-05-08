import 'package:fedodo_micro/APIs/ActivityPub/post_api.dart';
import 'package:fedodo_micro/APIs/ActivityPub/inbox_api.dart';
import 'package:fedodo_micro/Models/ActivityPub/ordered_collection_page.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../APIs/ActivityPub/outbox_api.dart';
import '../../Models/ActivityPub/activity.dart';
import '../../Models/ActivityPub/post.dart';
import '../../Views/PostViews/post.dart';

class PostList extends StatefulWidget {
  const PostList({
    Key? key,
    required this.appTitle,
    required this.firstPage,
    this.noReplies = false,
    this.isInbox = true,
    this.scrollController,
  }) : super(key: key);

  final String appTitle;
  final String firstPage;
  final bool noReplies;
  final bool isInbox;
  final ScrollController? scrollController;

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  late final PagingController<String, Activity<Post>> _paginationController =
      PagingController(firstPageKey: widget.firstPage);
  static const _pageSize = 20;

  @override
  void initState() {
    super.initState();

    _paginationController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(String pageKey) async {
    try {
      OrderedCollectionPage orderedCollectionPage;

      if (widget.isInbox) {
        InboxAPI inboxProvider = InboxAPI();
        orderedCollectionPage = await inboxProvider.getPosts(pageKey);
      } else {
        OutboxAPI provider = OutboxAPI();
        orderedCollectionPage = await provider.getPosts(pageKey);
      }

      List<Activity<Post>> activities = [];

      for (Activity activity in orderedCollectionPage.orderedItems) {
        if (widget.noReplies) {
          if (activity.type == "Create" && activity.object.inReplyTo == null) {
            activities.add(activity as Activity<Post>);
          } else if (activity.type == "Announce") {
            PostAPI postAPI = PostAPI();
            Post? post = await postAPI.getPost(activity.object);

            if (post == null){
              continue;
            }

            Activity<Post> addActivity = Activity(
              activity.to,
              post,
              activity.id,
              activity.type,
              activity.published,
              activity.actor,
              activity.context,
              activity.bto,
              activity.cc,
              activity.bcc,
              activity.audience,
            );
            activities.add(addActivity);
          }
        } else {
          if (activity.type == "Create") {
            activities.add(activity as Activity<Post>);
          } else if (activity.type == "Announce") {
            PostAPI postAPI = PostAPI();
            Post? post = await postAPI.getPost(activity.object);

            if (post == null){
              continue;
            }

            Activity<Post> addActivity = Activity(
              activity.to,
              post,
              activity.id,
              activity.type,
              activity.published,
              activity.actor,
              activity.context,
              activity.bto,
              activity.cc,
              activity.bcc,
              activity.audience,
            );
            activities.add(addActivity);
          }
        }
      }

      final isLastPage = orderedCollectionPage.orderedItems.length < _pageSize;
      if (isLastPage) {
        _paginationController.appendLastPage(activities);
      } else {
        final nextPageKey = orderedCollectionPage.next;
        _paginationController.appendPage(activities, nextPageKey);
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
      child: PagedListView<String, Activity<Post>>(
        scrollController: widget.scrollController,
        addSemanticIndexes: false,
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: true,
        clipBehavior: Clip.none,
        pagingController: _paginationController,
        builderDelegate: PagedChildBuilderDelegate<Activity<Post>>(
          itemBuilder: (context, item, index) => PostView(
            activity: item,
            appTitle: widget.appTitle,
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
