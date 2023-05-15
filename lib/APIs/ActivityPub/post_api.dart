import 'dart:convert';
import 'package:fedodo_micro/Extensions/url_extensions.dart';
import 'package:fedodo_micro/Globals/global_settings.dart';
import 'package:http/http.dart' as http;
import '../../Models/ActivityPub/post.dart';

class PostAPI {
  Future<Post?> getPost(String activityId) async {
    try {
      var activityUrl = Uri.parse(activityId);

      if(activityUrl.authority != GlobalSettings.domainName){
        activityUrl = activityUrl.asProxyUri();
      }

      http.Response response = await http.get(
        activityUrl,
        headers: <String, String>{"Accept": "application/json"},
      );

      String jsonString = response.body;

      Post post = Post.fromJson(jsonDecode(jsonString));
      return post;
    } catch (ex) {
      return null;
    }
  }
}
