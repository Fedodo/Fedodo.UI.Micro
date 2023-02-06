import 'dart:convert';

import 'package:fedodo_micro/Models/ActivityPub/ordered_collection.dart';
import 'package:http/http.dart' as http;

import '../Models/ActivityPub/post.dart';

class InboxProvider {
  final String accessToken;

  InboxProvider(this.accessToken);

  Future<OrderedCollection<Post>> getPosts() async {
    http.Response response = await http.get(
        Uri.parse(
            "https://dev.fedodo.social/inbox/e287834b-0564-4ece-b793-0ef323344959"), // TODO
        headers: <String, String>{
          "Authorization": "Bearer $accessToken"
        });

    String jsonString = response.body;
    OrderedCollection<Post> collection = OrderedCollection<Post>.fromJson(jsonDecode(jsonString));
    return collection;
  }
}
