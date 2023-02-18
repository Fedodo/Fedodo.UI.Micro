import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/ActivityPub/actor.dart';
import '../Models/ActivityPub/ordered_collection.dart';

class FollowersProvider{
  final String accessToken;

  FollowersProvider(this.accessToken);

  Future<OrderedCollection<Actor>> getFollowers(String followerEndpoint) async {

    http.Response response = await http.get(
        Uri.parse(followerEndpoint),
        headers: <String, String>{
          "Authorization": "Bearer $accessToken"
        });

    String jsonString = response.body;
    OrderedCollection<Actor> collection = OrderedCollection<Actor>.fromJson(jsonDecode(jsonString));
    return collection;
  }
}