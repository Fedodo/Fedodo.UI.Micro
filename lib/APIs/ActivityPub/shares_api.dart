import 'dart:convert';
import 'package:fedodo_micro/Models/ActivityPub/ordered_collection_page.dart';
import 'package:fedodo_micro/Globals/global_settings.dart';
import 'package:http/http.dart' as http;
import '../../Models/ActivityPub/ordered_paged_collection.dart';

class SharesAPI {
  Future<OrderedPagedCollection> getShares(String postId) async {
    String formattedUrl =
        "https://${GlobalSettings.domainName}/shares/${Uri.encodeQueryComponent(postId)}";

    http.Response response =
        await http.get(Uri.parse(formattedUrl), headers: <String, String>{});

    String jsonString = response.body;
    OrderedPagedCollection collection =
        OrderedPagedCollection.fromJson(jsonDecode(response.body));
    return collection;
  }

  Future<bool> isPostShared(String postId) async {
    OrderedPagedCollection shares = await getShares(postId);

    String url = shares.first!;
    do {
      http.Response response = await http.get(
        Uri.parse(url),
      );

      OrderedCollectionPage collection =
          OrderedCollectionPage.fromJson(jsonDecode(response.body));

      if (collection.orderedItems.isEmpty) {
        return false;
      }

      if (collection.orderedItems
          .where((element) => element.actor == GlobalSettings.actorId)
          .isNotEmpty) {
        return true;
      }

      url = collection.next!;
    } while (true);

    return false;
  }

  void share(String postId) async {
    Map<String, dynamic> body = {
      "to": ["as:Public"],
      "type": "Announce",
      "object": postId
    };

    String json = jsonEncode(body);

    var result = await http.post(
      Uri.parse("https://${GlobalSettings.domainName}/outbox/${GlobalSettings.userId}"),
      headers: <String, String>{
        "Authorization": "Bearer ${GlobalSettings.accessToken}",
        "content-type": "application/json",
      },
      body: json,
    );

    var bodyString = result.body;
  }
}
