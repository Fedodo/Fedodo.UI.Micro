import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Models/ActivityPub/ordered_collection.dart';

class LikesProvider{
  final String accessToken;

  LikesProvider(this.accessToken);

  Future<OrderedCollection<String>> getLikes(String postId) async {
    
    String formattedUrl = "https://dev.fedodo.social/likes/" + Uri.encodeQueryComponent(postId); // TODO
    
    http.Response response = await http.get(
        Uri.parse(formattedUrl),
        headers: <String, String>{
          "Authorization": "Bearer $accessToken"
        });

    String jsonString = response.body;
    OrderedCollection<String> collection = OrderedCollection<String>.fromJson(jsonDecode(jsonString));
    return collection;
  }
}