import 'dart:convert';
import 'package:fedodo_micro/Models/ActivityPub/ordered_collection_page.dart';
import 'package:http/http.dart' as http;
import '../Models/ActivityPub/post.dart';

class OutboxProvider {
  final String accessToken;

  OutboxProvider(this.accessToken);

  Future<OrderedCollectionPage<Post>> getPosts(int pageKey) async {
    http.Response pageResponse = await http.get(
        Uri.parse(
            "https://dev.fedodo.social/outbox/e287834b-0564-4ece-b793-0ef323344959/page/$pageKey"), //TODO
        headers: <String, String>{
          "Authorization": "Bearer $accessToken"
        }
    );

    String jsonString = pageResponse.body;

    OrderedCollectionPage<Post> collection = OrderedCollectionPage.fromJson(jsonDecode(jsonString));

    return collection;
  }
}
