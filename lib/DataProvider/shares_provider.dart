import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Models/ActivityPub/ordered_collection.dart';

class SharesProvider{
  final String accessToken;

  SharesProvider(this.accessToken);

  Future<OrderedCollection<String>> getShares(String postId) async {

    String formattedUrl = "https://dev.fedodo.social/shares/" + Uri.encodeQueryComponent(postId); // TODO

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