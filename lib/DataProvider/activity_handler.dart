import 'dart:convert';

import 'package:http/http.dart' as http;

class ActivityHandler {
  final String accessToken;

  ActivityHandler(this.accessToken);

  void like(String postId) async {
    Map<String, dynamic> body = {
      "to": ["as:Public"],
      "type": "Like",
      "object": postId
    };

    String json = jsonEncode(body);

    var result = await http.post(
      Uri.parse(
          "https://dev.fedodo.social/outbox/e287834b-0564-4ece-b793-0ef323344959"),
      // TODO
      headers: <String, String>{
        "Authorization": "Bearer $accessToken",
        "content-type": "application/json",
      },
      body: json,
    );

    var bodyString = result.body;
  }
}
