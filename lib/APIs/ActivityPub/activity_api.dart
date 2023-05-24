import 'dart:convert';
import 'package:fedodo_micro/APIs/auth_base_api.dart';
import 'package:fedodo_micro/Extensions/url_extensions.dart';
import 'package:fedodo_micro/Globals/preferences.dart';
import 'package:http/http.dart' as http;
import '../../Models/ActivityPub/activity.dart';
import '../../Models/ActivityPub/post.dart';

class ActivityAPI {

  void follow(Uri object) async {

    Map<String, dynamic> body = {
      "to": ["as:Public"],
      "type": "Follow",
      "object": object.toString()
    };

    String json = jsonEncode(body);

    var result = await AuthBaseApi.post(
      url: Uri.parse("https://${Preferences.prefs!.getString("DomainName")}/outbox/${Preferences.prefs!.getString("UserId")}"),
      body: json,
      headers: <String, String>{
        "content-type": "application/json",
      },
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

    var result = await AuthBaseApi.post(
      url: Uri.parse("https://${Preferences.prefs!.getString("DomainName")}/outbox/${Preferences.prefs!.getString("UserId")}"),
      headers: <String, String>{
        "content-type": "application/json",
      },
      body: json,
    );

    var bodyString = result.body;
  }

  Future<Activity<Post>> getActivity(String activityId) async {

    Uri activityUri = Uri.parse(activityId);

    if(activityUri.authority != Preferences.prefs!.getString("DomainName")){
      activityUri = activityUri.asProxyUri();
    }

    http.Response response = await http.get(
      activityUri,
      headers: <String, String>{
        "Accept": "application/json",
      },
    );

    Activity<Post> activity = Activity.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

    return activity;
  }
}
