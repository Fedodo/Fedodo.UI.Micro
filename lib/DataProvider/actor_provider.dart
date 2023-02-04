import 'dart:convert';

import 'package:fedodo_micro/Models/ActivityPub/actor.dart';
import 'package:http/http.dart' as http;

class ActorProvider {
  final String accessToken;

  ActorProvider(this.accessToken);

  Future<Actor> getActor(String actorId) async {
    http.Response response = await http.get(
      Uri.parse(actorId),
      headers: <String, String>{
        "Authorization": "Bearer $accessToken",
        "Accept": "application/json",
      },
    );

    String jsonString = response.body;
    Actor actor = Actor.fromJson(jsonDecode(jsonString));

    return actor;
  }
}
