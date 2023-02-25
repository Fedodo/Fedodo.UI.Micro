import 'dart:convert';
import 'package:fedodo_micro/Models/ActivityPub/ordered_collection_page.dart';
import 'package:fedodo_micro/Models/ActivityPub/ordered_paged_collection.dart';
import 'package:http/http.dart' as http;
import '../Models/ActivityPub/post.dart';

class OutboxProvider {
  Future<OrderedPagedCollection> getFirstPage(String outboxUrl) async {
    http.Response pageResponse = await http.get(Uri.parse(outboxUrl));
    OrderedPagedCollection collection = OrderedPagedCollection.fromJson(jsonDecode(pageResponse.body));
    return collection;
  }

  Future<OrderedCollectionPage<Post>> getPosts(String nextUrl) async {
    http.Response pageResponse = await http.get(Uri.parse(nextUrl));

    String jsonString = pageResponse.body;

    OrderedCollectionPage<Post> collection = OrderedCollectionPage.fromJson(jsonDecode(jsonString));

    return collection;
  }
}
