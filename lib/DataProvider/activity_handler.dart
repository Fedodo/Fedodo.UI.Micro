import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../Models/ActivityPub/activity.dart';

class ActivityHandler {
  final String accessToken;

  ActivityHandler(this.accessToken);

  void post(String content, String? inReplyTo) async {
    Map<String, dynamic> body = {
      "to": ["as:Public"],
      "type": "Create",
      "object": {
        "to": ["as:Public"],
        "type": "Note",
        "content": content,
        "published": DateTime.now().toUtc().toIso8601String(),
      }
    };

    if (inReplyTo != null){
      body["object"]["inReplyTo"] = inReplyTo;
    }

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

  void share(String postId) async {
    Map<String, dynamic> body = {
      "to": ["as:Public"],
      "type": "Announce",
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

  Future<Activity> getActivity(String activityId) async{
    http.Response response = await http.get(Uri.parse(activityId),
      headers: <String, String>{
        "Accept": "application/json",
      },
    );

    String jsonString = response.body;
    Activity activity = Activity.fromJson(jsonDecode(jsonString));

    return activity;
  }
}
