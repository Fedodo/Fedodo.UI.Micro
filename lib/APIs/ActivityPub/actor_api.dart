import 'dart:convert';
import 'package:fedodo_micro/Extensions/url_extensions.dart';
import 'package:fedodo_micro/Models/ActivityPub/actor.dart';
import 'package:http/http.dart' as http;
import '../../Globals/global_settings.dart';

class ActorAPI {
  Future<Actor> getActor(String actorId) async {

    var actorUri = Uri.parse(actorId);

    if(actorUri.authority != GlobalSettings.domainName){
      actorUri = actorUri.asProxyUri();
    }

    http.Response response = await http.get(
      actorUri,
      headers: <String, String>{
        "Accept": "application/json",
      },
    );

    Actor actor = Actor.fromJson(jsonDecode(response.body));

    return actor;
  }
}
