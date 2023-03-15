import 'dart:convert';
import 'package:fedodo_micro/Models/ActivityPub/ordered_collection_page.dart';
import 'package:http/http.dart' as http;
import '../../Models/ActivityPub/activity.dart';
import '../../Models/ActivityPub/ordered_paged_collection.dart';
import '../../Models/ActivityPub/post.dart';

class InboxAPI {
  final String accessToken;

  InboxAPI(this.accessToken);

  Future<OrderedPagedCollection> getFirstPage(String inboxUrl) async {
    http.Response pageResponse = await http.get(Uri.parse(inboxUrl));
    OrderedPagedCollection collection =
        OrderedPagedCollection.fromJson(jsonDecode(pageResponse.body));
    return collection;
  }

  Future<OrderedCollectionPage> getPosts(String nextUrl) async {
    http.Response pageResponse = await http.get(
      Uri.parse(nextUrl),
      headers: <String, String>{"Authorization": "Bearer $accessToken"},
    );

    String jsonString = pageResponse.body;

    OrderedCollectionPage collection =
        OrderedCollectionPage.fromJson(jsonDecode(jsonString));

    return collection;
  }
}
