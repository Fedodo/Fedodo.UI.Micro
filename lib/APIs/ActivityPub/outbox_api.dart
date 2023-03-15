import 'dart:convert';
import 'package:fedodo_micro/Models/ActivityPub/ordered_collection_page.dart';
import 'package:fedodo_micro/Models/ActivityPub/ordered_paged_collection.dart';
import 'package:http/http.dart' as http;
import '../../Models/ActivityPub/activity.dart';
import '../../Models/ActivityPub/post.dart';

class OutboxAPI {
  Future<OrderedPagedCollection> getFirstPage(String outboxUrl) async {
    http.Response pageResponse = await http.get(Uri.parse(outboxUrl));
    OrderedPagedCollection collection = OrderedPagedCollection.fromJson(jsonDecode(pageResponse.body));
    return collection;
  }

  Future<OrderedCollectionPage> getPosts(String nextUrl) async {
    http.Response pageResponse = await http.get(Uri.parse(nextUrl));

    String jsonString = pageResponse.body;

    OrderedCollectionPage collection = OrderedCollectionPage.fromJson(jsonDecode(jsonString));

    return collection;
  }
}