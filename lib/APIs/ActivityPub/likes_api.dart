import 'dart:convert';
import 'package:fedodo_micro/APIs/auth_base_api.dart';
import 'package:http/http.dart' as http;
import '../../Globals/preferences.dart';
import '../../Models/ActivityPub/ordered_collection_page.dart';
import '../../Models/ActivityPub/ordered_paged_collection.dart';

class LikesAPI{
  Future<OrderedPagedCollection> getLikes(String postId) async {
    String formattedUrl = "https://${Preferences.prefs!.getString("DomainName")}/likes/${Uri.encodeQueryComponent(postId)}";

    http.Response response =
    await http.get(Uri.parse(formattedUrl), headers: <String, String>{});

    String jsonString = response.body;
    OrderedPagedCollection collection =
    OrderedPagedCollection.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    return collection;
  }

  Future<bool> isPostLiked(String postId) async {
    OrderedPagedCollection likes = await getLikes(postId);

    String url = likes.first!;
    do {
      http.Response response = await http.get(
        Uri.parse(url),
      );

      OrderedCollectionPage collection = OrderedCollectionPage.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      if (collection.orderedItems.isEmpty){
        return false;
      }

      if (collection.orderedItems.where((element) => element.actor == Preferences.prefs!.getString("ActorId")).isNotEmpty){
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

    var result = await AuthBaseApi.post(
      url: Uri.parse("https://${Preferences.prefs!.getString("DomainName")}/outbox/${Preferences.prefs!.getString("DomainName")}"),
      headers: <String, String>{
        "content-type": "application/json",
      },
      body: json,
    );

    var bodyString = result.body;
  }
}