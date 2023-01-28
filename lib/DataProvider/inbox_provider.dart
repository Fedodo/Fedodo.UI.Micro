import 'dart:convert';

import 'package:fedodo_micro/Models/ActivityPub/ordered_collection.dart';
import 'package:http/http.dart' as http;

import '../Models/ActivityPub/post.dart';

class InboxProvider {
  final String accessToken;

  InboxProvider(this.accessToken);

  void getPosts() async {
    http.Response response = await http.get(
        Uri.parse(
            "https://dev.fedodo.social/inbox/50e4f154-a329-45d3-9769-7ed3ac1f5ee4"),
        headers: <String, String>{
          "Authorization": "Bearer $accessToken"
        });

    String jsonString = response.body;
    OrderedCollection<Post> collection = OrderedCollection.fromJson(jsonDecode(jsonString));
  }
}
