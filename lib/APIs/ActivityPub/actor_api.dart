import 'dart:convert';
import 'package:fedodo_micro/Models/ActivityPub/actor.dart';
import 'package:http/http.dart' as http;

class ActorAPI {
  Future<Actor> getActor(String actorId) async {
    http.Response response = await http.get(
      Uri.parse(actorId),
      headers: <String, String>{
        "Accept": "application/json",
      },
    );

    Actor actor = Actor.fromJson(jsonDecode(response.body));

    return actor;
  }
}
