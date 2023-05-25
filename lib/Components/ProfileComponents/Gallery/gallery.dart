import 'package:cached_network_image/cached_network_image.dart';
import 'package:fedodo_micro/APIs/ActivityPub/inbox_api.dart';
import 'package:fedodo_micro/APIs/ActivityPub/outbox_api.dart';
import 'package:fedodo_micro/Components/ProfileComponents/Gallery/photo_detail.dart';
import 'package:fedodo_micro/Extensions/url_extensions.dart';
import 'package:fedodo_micro/Models/ActivityPub/ObjectTypes/document.dart';
import 'package:fedodo_micro/Models/ActivityPub/activity.dart';
import 'package:fedodo_micro/Models/ActivityPub/ordered_collection_page.dart';
import 'package:fedodo_micro/Models/ActivityPub/post.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class Gallery extends StatefulWidget {
  const Gallery({
    Key? key,
    required this.firstPage,
    this.isInbox = true,
    this.scrollController,
    required this.appTitle,
  }) : super(key: key);

  final String firstPage;
  final bool isInbox;
  final ScrollController? scrollController;
  final String appTitle;

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
          itemBuilder: (context, item, index) => Ink.image(
            image: CachedNetworkImageProvider(
              item.url?.asProxyUri().toString() ?? "", // TODO Handle null
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 300),
                    reverseTransitionDuration:
                        const Duration(milliseconds: 300),
                    pageBuilder: (context, animation, animation2) =>
                        PhotoDetail(
                      title: widget.appTitle,
                      url: item.url?.asProxyUri().toString() ??
                          "", // TODO Handle null
                    ),
                    transitionsBuilder:
                        (context, animation, animation2, widget) =>
                            SlideTransition(
                                position: Tween(
                                  begin: const Offset(1.0, 0.0),
                                  end: const Offset(0.0, 0.0),
                                ).animate(animation),
                                child: widget),
                  ),
                );
              },
            ),
          ),
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
