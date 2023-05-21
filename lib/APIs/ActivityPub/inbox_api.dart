import 'dart:convert';
import 'package:fedodo_micro/APIs/auth_base_api.dart';
import 'package:fedodo_micro/Models/ActivityPub/ordered_collection_page.dart';
import 'package:http/http.dart' as http;
import '../../Models/ActivityPub/ordered_paged_collection.dart';

class InboxAPI {

  Future<OrderedPagedCollection> getFirstPage(String inboxUrl) async {
    http.Response pageResponse = await http.get(Uri.parse(inboxUrl));
    OrderedPagedCollection collection =
        OrderedPagedCollection.fromJson(jsonDecode(pageResponse.body));
    return collection;
  }

  Future<OrderedCollectionPage> getPosts(String nextUrl) async {
    http.Response pageResponse = await AuthBaseApi.get(
      url: Uri.parse(nextUrl),
    );

    OrderedCollectionPage collection = OrderedCollectionPage.fromJson(jsonDecode(utf8.decode(pageResponse.bodyBytes)));

    return collection;
  }
}
