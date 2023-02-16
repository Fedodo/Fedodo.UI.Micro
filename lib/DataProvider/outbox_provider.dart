import 'dart:convert';

import 'package:fedodo_micro/Models/ActivityPub/ordered_collection.dart';
import 'package:http/http.dart' as http;

import '../Models/ActivityPub/post.dart';

class OutboxProvider {
  final String accessToken;

  OutboxProvider(this.accessToken);

  Future<OrderedCollection<Post>> getPosts(String outbox) async {
    http.Response response = await http.get(
        Uri.parse(outbox),
        headers: <String, String>{
          "Authorization": "Bearer $accessToken"
        });

    String jsonString = response.body;
    OrderedCollection<Post> collection = OrderedCollection<Post>.fromJson(jsonDecode(jsonString));
    return collection;
  }
}
