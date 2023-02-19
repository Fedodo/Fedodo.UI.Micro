import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/ActivityPub/actor.dart';
import '../Models/ActivityPub/ordered_collection.dart';

class FollowingProvider {
  FollowingProvider();

  Future<OrderedCollection<Actor>> getFollowings(String followingsEndpoint) async {
    http.Response response = await http.get(Uri.parse(followingsEndpoint), headers: <String, String>{});

    String jsonString = response.body;
    OrderedCollection<Actor> collection = OrderedCollection<Actor>.fromJson(jsonDecode(jsonString));
    return collection;
  }
}