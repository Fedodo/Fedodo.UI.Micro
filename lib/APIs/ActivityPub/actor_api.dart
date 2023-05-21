import 'dart:convert';
import 'package:fedodo_micro/Extensions/url_extensions.dart';
import 'package:fedodo_micro/Models/ActivityPub/actor.dart';
import 'package:http/http.dart' as http;

import '../../Globals/preferences.dart';

class ActorAPI {
  Future<Actor> getActor(String actorId) async {

    var actorUri = Uri.parse(actorId);

    if(actorUri.authority != Preferences.prefs!.getString("DomainName")){
      actorUri = actorUri.asProxyUri();
    }

    http.Response response = await http.get(
      actorUri,
      headers: <String, String>{
        "Accept": "application/json",
      },
    );

    String utf8String = utf8.decode(response.bodyBytes);
    
    Actor actor = Actor.fromJson(jsonDecode(utf8String));

    return actor;
  }
}
