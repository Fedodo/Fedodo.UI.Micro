import 'package:activitypub/activitypub.dart';
import 'package:fedodo_general/globals/general.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
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
      OrderedCollectionPage<Activity> orderedCollectionPage;

      if (widget.isInbox) {
        InboxAPI inboxProvider = InboxAPI();
        orderedCollectionPage = await inboxProvider.getPosts<Activity>(pageKey);
      } else {
        OutboxAPI provider = OutboxAPI();
        orderedCollectionPage = await provider.getPosts<Activity>(pageKey);
      }

      List<Activity<Post>> activities = [];

      for (Activity activity in orderedCollectionPage.orderedItems) {
        if (widget.noReplies) {
          if (activity.type == "Create" && activity.object.inReplyTo == null) {
            activities.add(activity as Activity<Post>);
          } else if (activity.type == "Announce") {
            PostAPI postAPI = PostAPI();
            Post? post = await postAPI.getPost(activity.object);

            if (post == null) {
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

            if (post == null) {
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
      General.logger.e(error, "An error occurred in PostList.");
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
