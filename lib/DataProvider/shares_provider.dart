import 'dart:convert';
import 'package:fedodo_micro/Models/ActivityPub/ordered_collection_page.dart';
import 'package:http/http.dart' as http;
import '../Models/ActivityPub/ordered_collection.dart';
import '../Models/ActivityPub/ordered_paged_collection.dart';

class SharesProvider {
  final String accessToken;

  SharesProvider(this.accessToken);

  Future<OrderedPagedCollection> getShares(String postId) async {
    String formattedUrl = "https://dev.fedodo.social/shares/" +
        Uri.encodeQueryComponent(postId); // TODO

    http.Response response =
        await http.get(Uri.parse(formattedUrl), headers: <String, String>{});

    String jsonString = response.body;
    OrderedPagedCollection collection =
        OrderedPagedCollection.fromJson(jsonDecode(response.body));
    return collection;
  }

  Future<bool> isPostShared(String postId, String actorId) async {
    OrderedPagedCollection shares = await getShares(postId);

    String url = shares.first!;
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
}
