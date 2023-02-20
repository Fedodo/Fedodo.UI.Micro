import 'package:fedodo_micro/DataProvider/inbox_provider.dart';
import 'package:fedodo_micro/Models/ActivityPub/ordered_collection.dart';
import 'package:fedodo_micro/Views/PostViews/post.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

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

  late InboxProvider provider;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const _pageSize = 20;
  final PagingController<int, Post> _pagingController =
      PagingController(firstPageKey: 1);

  late Future<OrderedCollection<Post>> collectionFuture;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  // Future<OrderedCollection<Post>> onRefresh() {
  //   Future<OrderedCollection<Post>> refreshFuture = widget.provider.getPosts(0);
  //
  //   setState(() {
  //     collectionFuture = refreshFuture;
  //   });
  //
  //   return refreshFuture;
  // }

  Future<void> _fetchPage(int pageKey) async {
    try {
      InboxProvider provider = InboxProvider(widget.accessToken);

      final newItems = await provider.getPosts(pageKey);
      final isLastPage = newItems.orderedItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems.orderedItems);
      } else {
        final nextPageKey = pageKey + newItems.orderedItems.length;
        _pagingController.appendPage(newItems.orderedItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, Post>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<Post>(
        itemBuilder: (context, item, index) => PostView(
          post: item,
          accessToken: widget.accessToken,
          appTitle: widget.appTitle,
          replies: const [], // TODO
          userId: widget.userId,
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
