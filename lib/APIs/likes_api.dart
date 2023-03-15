import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/ActivityPub/ordered_collection.dart';
import '../Models/ActivityPub/ordered_collection_page.dart';
import '../Models/ActivityPub/ordered_paged_collection.dart';

class LikesAPI{
  final String accessToken;

  LikesAPI(this.accessToken);

  Future<OrderedPagedCollection> getLikes(String postId) async {
    String formattedUrl = "https://dev.fedodo.social/likes/" +
        Uri.encodeQueryComponent(postId); // TODO

    http.Response response =
    await http.get(Uri.parse(formattedUrl), headers: <String, String>{});

    String jsonString = response.body;
    OrderedPagedCollection collection =
    OrderedPagedCollection.fromJson(jsonDecode(response.body));
    return collection;
  }

  Future<bool> isPostLiked(String postId, String actorId) async {
    OrderedPagedCollection likes = await getLikes(postId);

    String url = likes.first!;
    do {
      http.Response response = await http.get(
        Uri.parse(url),
      );

      OrderedCollectionPage collection = OrderedCollectionPage.fromJson(jsonDecode(response.body));

      if (collection.orderedItems.isEmpty){
        return false;
      }

      if (collection.orderedItems.where((element) => element.actor == actorId).isNotEmpty){
        return true;
      }

      url = collection.next!;
    } while (true);

    return false;
  }

  void like(String postId) async {
    Map<String, dynamic> body = {
      "to": ["as:Public"],
      "type": "Like",
      "object": postId
    };

    String json = jsonEncode(body);

    var result = await http.post(
      Uri.parse(
          "https://dev.fedodo.social/outbox/e287834b-0564-4ece-b793-0ef323344959"),
      // TODO
      headers: <String, String>{
        "Authorization": "Bearer $accessToken",
        "content-type": "application/json",
      },
      body: json,
    );

    var bodyString = result.body;
  }
}