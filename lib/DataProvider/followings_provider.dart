import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/ActivityPub/actor.dart';
import '../Models/ActivityPub/ordered_collection.dart';

class FollowingProvider {
  FollowingProvider();

  Future<OrderedCollection> getFollowings(
      String followingsEndpoint) async {
    http.Response response = await http.get(
      Uri.parse(followingsEndpoint),
      headers: <String, String>{
        "Accept": "application/json"
      },
    );

    String jsonString = response.body;
    OrderedCollection collection = OrderedCollection.fromJson(jsonDecode(jsonString));
    return collection;
  }
}
