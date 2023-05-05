import 'dart:convert';
import 'package:fedodo_micro/global_settings.dart';
import 'package:http/http.dart' as http;
import '../../Models/ActivityPub/ordered_collection_page.dart';
import '../../Models/ActivityPub/ordered_paged_collection.dart';

class LikesAPI{
  final String domainName;
  final String actorId;

  LikesAPI(this.domainName, this.actorId);

  Future<OrderedPagedCollection> getLikes(String postId) async {
    String formattedUrl = "https://$domainName/likes/${Uri.encodeQueryComponent(postId)}";

    http.Response response =
    await http.get(Uri.parse(formattedUrl), headers: <String, String>{});

    String jsonString = response.body;
    OrderedPagedCollection collection =
    OrderedPagedCollection.fromJson(jsonDecode(jsonString));
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
      Uri.parse("https://$domainName/outbox/$actorId"),
      headers: <String, String>{
        "Authorization": "Bearer ${GlobalSettings.accessToken}",
        "content-type": "application/json",
      },
      body: json,
    );

    var bodyString = result.body;
  }
}