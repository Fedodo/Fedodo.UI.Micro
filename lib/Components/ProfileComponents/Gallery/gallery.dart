import 'package:fedodo_micro/APIs/ActivityPub/inbox_api.dart';
import 'package:fedodo_micro/APIs/ActivityPub/outbox_api.dart';
import 'package:fedodo_micro/Extensions/url_extensions.dart';
import 'package:fedodo_micro/Models/ActivityPub/ObjectTypes/document.dart';
import 'package:fedodo_micro/Models/ActivityPub/activity.dart';
import 'package:fedodo_micro/Models/ActivityPub/ordered_collection_page.dart';
import 'package:fedodo_micro/Models/ActivityPub/post.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:fedodo_micro/Extensions/string_extensions.dart';

class Gallery extends StatefulWidget {
  const Gallery({
    Key? key,
    required this.firstPage,
    this.isInbox = true,
    this.scrollController,
  }) : super(key: key);

  final String firstPage;
  final bool isInbox;
  final ScrollController? scrollController;

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  late final PagingController<String, Document> _paginationController =
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

      List<Document> activities = [];

      for (Activity activity in orderedCollectionPage.orderedItems) {
        if (activity.type == "Create" && activity.object.inReplyTo == null) {
          var convertedActivity = activity as Activity<Post>;

          if (convertedActivity.object.attachment != null &&
              convertedActivity.object.attachment!.isNotEmpty) {
            activities.addAll(convertedActivity.object.attachment!);
          }
        }
      }

      final isLastPage = false; // TODO
      // final isLastPage = orderedCollectionPage.orderedItems.length < _pageSize;
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
      child: PagedGridView<String, Document>(
        scrollController: widget.scrollController,
        addSemanticIndexes: false,
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: true,
        clipBehavior: Clip.none,
        pagingController: _paginationController,
        builderDelegate: PagedChildBuilderDelegate<Document>(
          itemBuilder: (context, item, index) => Image.network(
              item.url?.asProxyUri().toString() ?? ""), // TODO Handle null
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 16,
          crossAxisSpacing: 0,
          childAspectRatio: 2,
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
