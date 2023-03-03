import 'dart:convert';
import 'package:fedodo_micro/Models/ActivityPub/ordered_collection_page.dart';
import 'package:http/http.dart' as http;
import '../Models/ActivityPub/actor.dart';
import '../Models/ActivityPub/ordered_collection.dart';
import '../Models/ActivityPub/ordered_paged_collection.dart';

class FollowingProvider {
  FollowingProvider();

  Future<OrderedPagedCollection> getFollowings(
      String followingsEndpoint) async {
    http.Response response = await http.get(
      Uri.parse(followingsEndpoint),
      headers: <String, String>{
        "Accept": "application/json"
      },
    );

    String jsonString = response.body;
    OrderedPagedCollection collection =
        OrderedPagedCollection.fromJson(jsonDecode(jsonString));
    return collection;
  }
}
