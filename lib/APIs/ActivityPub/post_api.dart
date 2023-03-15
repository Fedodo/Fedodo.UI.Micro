import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Models/ActivityPub/activity.dart';
import '../../Models/ActivityPub/post.dart';

class PostAPI{

  final String accessToken;

  PostAPI(this.accessToken);

  Future<Post> getPost(String activityId) async{
    http.Response response = await http.get(Uri.parse(activityId),
      headers: <String, String>{
      "Accept": "application/json"
      },
    );

    String jsonString = response.body;
    Post post = Post.fromJson(jsonDecode(jsonString));

    return post;
  }
}