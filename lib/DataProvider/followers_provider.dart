import 'dart:convert';
import 'package:fedodo_micro/Models/ActivityPub/ordered_paged_collection.dart';
import 'package:http/http.dart' as http;
import '../Models/ActivityPub/actor.dart';
import '../Models/ActivityPub/ordered_collection.dart';

class FollowersProvider {
  FollowersProvider();

  Future<OrderedPagedCollection> getFollowers(String followerEndpoint) async {
    http.Response response = await http.get(
      Uri.parse(followerEndpoint),
      headers: <String, String>{
        "Accept": "application/json"
      },
    );

    String jsonString = response.body;
    OrderedPagedCollection collection = OrderedPagedCollection.fromJson(jsonDecode(jsonString));
    return collection;
  }
}
