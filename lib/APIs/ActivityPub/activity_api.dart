import 'dart:convert';
import 'package:fedodo_micro/global_settings.dart';
import 'package:http/http.dart' as http;
import '../../Models/ActivityPub/activity.dart';
import '../../Models/ActivityPub/post.dart';

class ActivityAPI {
  final String userId;
  final String domainName;

  ActivityAPI(this.userId, this.domainName);

  void follow(String object) async {
    Map<String, dynamic> body = {
      "to": ["as:Public"],
      "type": "Follow",
      "object": object
    };

    String json = jsonEncode(body);

    var result = await http.post(
      Uri.parse("https://$domainName/outbox/$userId"),
      headers: <String, String>{
        "Authorization": "Bearer ${GlobalSettings.accessToken}",
        "content-type": "application/json",
      },
      body: json,
    );

    var bodyString = result.body;
  }

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

    if (inReplyTo != null) {
      body["object"]["inReplyTo"] = inReplyTo;
    }

    String json = jsonEncode(body);

    var result = await http.post(
      Uri.parse("https://$domainName/outbox/$userId"),
      headers: <String, String>{
        "Authorization": "Bearer ${GlobalSettings.accessToken}",
        "content-type": "application/json",
      },
      body: json,
    );

    var bodyString = result.body;
  }

  Future<Activity<Post>> getActivity(String activityId) async {
    http.Response response = await http.get(
      Uri.parse(activityId),
      headers: <String, String>{
        "Accept": "application/json",
      },
    );

    String jsonString = response.body;
    Activity<Post> activity = Activity.fromJson(jsonDecode(jsonString));

    return activity;
  }
}
