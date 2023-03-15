import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Models/ActivityPub/activity.dart';
import '../../Models/ActivityPub/post.dart';

class ActivityAPI {
  final String accessToken;

  ActivityAPI(this.accessToken);

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

  Future<Activity<Post>> getActivity(String activityId) async{
    http.Response response = await http.get(Uri.parse(activityId),
      headers: <String, String>{
        "Accept": "application/json",
      },
    );

    String jsonString = response.body;
    Activity<Post> activity = Activity.fromJson(jsonDecode(jsonString));

    return activity;
  }
}
